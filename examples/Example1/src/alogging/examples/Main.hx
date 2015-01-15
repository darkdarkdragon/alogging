package alogging.examples;

//import neko.Lib;
import alogging.Logging;

private typedef L = Logging;


/**
 * ...
 * @author Ivan Tivonenko
 */
class TestObj {
    public var X = 1;
    public inline function new() {

    }
}

class Main {

	static function main() {
        L.init();

        var n = 1;
        var s = '-!Finest is goot!-';
        var obj = {
            f1: 1,
            fs: 'str'
        }
        var tobj = new TestObj();

//        L.finest('N', s);
//        L.setLevel(CONFIG);
//        L.finest('N', n);
//        L.finest('N', 1);
//        L.finest('N', obj);
        L.finest(obj);
//        L.finest('N', ' MESS! $s');
//        L.finest(' ROOT MESS! $s');
        L.finest(2);
//        L.finest('SU.B.A', ' subba!');

//        trace(obj);
        L.fine('N', tobj);
        L.fine(tobj);
//        trace(tobj);
//        L.severe('All is bad');
//        L.finest('finest and coolest');
//        L.finer('just finer var n : $n');
//        L.fine(CAT.TWO, 'fine sub-cat message');
        L.config('JUSTLOGGER', 'config from JUSTLOGGER');


        L.setLoggerLevel('N2', CONFIG);
        L.fine('N2', 'logged at n2 logger at fine level');
        L.config('N2', 'logged at n2 logger at config level');
//        L.info(ROOT, 'Hello!');
//        L.warning('Bad!');
//        L.warn('Same Bad!');
	}

}
