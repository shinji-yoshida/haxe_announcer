package announcer;

import massive.munit.Assert;
import announcer.Announcer;

class SampleListener{
  public function new(){}
  public dynamic function onSomeEventHappened(param:Int):Void{
  }
}


class AnnouncerTest 
{
  @Test
  public function testAnnounceEvent(){
    var subject:Announcer<SampleListener> = Announcer.to(SampleListener);
    var listener1:SampleListener = new SampleListener();
    var listener2:SampleListener = new SampleListener();
    var givenParam1:Int = 0;
    var givenParam2:Int = 0;
    listener1.onSomeEventHappened = function( param : Int ){givenParam1 = param;};
    listener2.onSomeEventHappened = function( param : Int ){givenParam2 = param;};
    subject.addListener(listener1);
    subject.addListener(listener2);
    // exercise
    subject.announce().onSomeEventHappened(3);
    // verify
    Assert.areEqual(3, givenParam1);
    Assert.areEqual(3, givenParam2);
  }
}