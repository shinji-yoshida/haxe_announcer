
package announcer;

class AnnounceFunction<T>{
  private var listeners:List<T>;
  private var methodName:String;

  public function new(listeners:List<T>, methodName:String){
    this.listeners = listeners;
    this.methodName = methodName;
  }

  public function announce(args:Array<Dynamic>):Void{
    for(each in listeners)
      Reflect.callMethod(each, Reflect.field(each, methodName), args);
  }
}


class Announcer<T>
{
  private var proxy:T;
  private var listeners:List<T>;
  private var announceFunctions:Array<AnnounceFunction<T>>;

  private function new(cls:Class<T>)
  {
    listeners = new List<T>();
    announceFunctions = [];
    proxy = Type.createEmptyInstance(cls);

    for(name in listenerMethodNames(cls)){
      var announceFunction = new AnnounceFunction(listeners, name);
      var announce = Reflect.makeVarArgs(announceFunction.announce);
      Reflect.setField(proxy, name, announce);
      announceFunctions.push(announceFunction);
    }
  }

  private function listenerMethodNames(cls:Class<T>):List<String>{
    return Lambda.filter(Type.getInstanceFields(cls),
      function(name){
        return Reflect.isFunction(Reflect.field(proxy, name));
      });
  }

  public static function to<T>(cls:Class<T>):Announcer<T>{
    return new Announcer<T>(cls);
  }

  public function announce():T{
    return proxy;
  }

  public function addListener(listener:T):Void
  {
    listeners.push(listener);
  }

  public function removeListener(listener:T):Void{
    listeners.remove(listener);
  }
}