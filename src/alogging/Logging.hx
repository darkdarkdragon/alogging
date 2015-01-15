package alogging;

//import haxe.ds.StringMap;

//import thx.promise.Promise;
//import thx.core.Nil;
import haxe.Serializer;
import haxe.Unserializer;

#if !macro
import haxe.rtti.Meta;
#end


#if macro
import haxe.macro.Expr;
using haxe.macro.Context;
using haxe.macro.Tools;
import haxe.macro.Type;
#end
//import haxe.macro.Context;
//import haxe.macro.Type;
//import haxe.macro.TypeTools;
//using haxe.macro.Context;

/**
 * Main class for logging.
 * No hierarchy of loggers supported yet.
 *
 * @author Ivan Tivonenko
 */

#if macro

/*
class Logger {
    function handle() {
    }
}
*/

//class Handler {
//}

//#if js

class JSConsoleHandler {

    public static function handle(level: Level, logger: String, message: Expr) {
//        var levelNum = Logging.levelNum(level);
        var method = switch (level) {
            case CONFIG, INFO: 'info';
            case WARNING: 'warn';
            case SEVERE: 'error';
            default: 'log';
        }
//        return macro { if ($v{levelNum} >= alogging.Logging._globalLevel) untyped console.$method('$logger - ' + $e{message}); }
//        return macro {  untyped console.$method('$logger - ' + $e{message}); }
        return macro {  untyped console.$method('$logger -', $e{message}); }
    }
}

//typedef Handler = JSConsoleHandler;

//#elseif neko

class TraceHandler {

    public static function handle(level: Level, logger: String, message: Expr) {
//        var levelNum = Logging.levelNum(level);
//        return macro { if ($v{levelNum} >= alogging.Logging._globalLevel ) trace('$logger - ' + $e{message}); }
        return macro {  trace('$logger - ' + $e{message}); }
    }
}

//typedef Handler = TraceHandler;

//#end


class Formatter {

}

/*
class LoggingBuilder {

	static var FIRST_COMPILATION = true;

    public static function onBuild() : Array<Field> {
//        trace('FIRST_COMPILATION: $FIRST_COMPILATION');
		if( FIRST_COMPILATION || true) {
			FIRST_COMPILATION = false;
			Context.onMacroContextReused(function() {
//                trace('onMacroContextReused');
//                Logging.nonRootLoggersUsed = false;
//                Logging.runtimeInitCalled = false;
//				RTTI = false;
//				GLOBAL = null;
				return false;
//				return true;
			});
		}
        Context.registerModuleReuseCall("alogging.Logging", "alogging.Logging.LoggingBuilder.onBuild()");
        return null;
    }
}
*/

#end

//#if !macro @:build(alogging.Logging.LoggingBuilder.onBuild()) #end
@:allow(alogging)
class Logging {

    macro public static function finest(loggerOrMessage: Expr, ?message: Expr) {
        return log(FINEST, loggerOrMessage, message);
    }

    macro public static function finer(loggerOrMessage: Expr, ?message: Expr) {
        return log(FINER, loggerOrMessage, message);
    }

    macro public static function fine(loggerOrMessage: Expr, ?message: Expr) {
        return log(FINE, loggerOrMessage, message);
    }

    macro public static function config(loggerOrMessage: Expr, ?message: Expr) {
        return log(CONFIG, loggerOrMessage, message);
    }

    macro public static function info(loggerOrMessage: Expr, ?message: Expr) {
        return log(INFO, loggerOrMessage, message);
    }

    macro public static function warning(loggerOrMessage: Expr, ?message: Expr) {
        return log(WARNING, loggerOrMessage, message);
    }

    macro public static function warn(loggerOrMessage: Expr, ?message: Expr) {
        return log(WARNING, loggerOrMessage, message);
    }

    macro public static function severe(loggerOrMessage: Expr, ?message: Expr) {
        return log(SEVERE, loggerOrMessage, message);
    }

//    macro public static function setLoggerLevel(logger: Expr, level: Level) {
//        trace('logger $logger');
//        return macro {};
//    }

    /**
     * Initializes logging system.
     * If configStr not null then it is used as config and do not tries to read config from disk.
     *
     * @param configStr YAML formatted string to use as config
     * @param configFileName Overrides default config file name
     * @return
     */
    macro public static function init(?configStr: String, ?configFileName: String) {
        runtimeInitCalled = true;
        /*
        var mh = Context.getType('alogging.meta.MetaHolder');
//        trace(mh);
        var ct = mh.getClass();
//        trace(ct.meta);
        ct.meta.add('initCalled', [], Context.currentPos());
        */

        return macro { alogging.Logging._init($v{configStr}, $v{configFileName}); }
    }

#if !macro

    /**
     * Sets global maximum logging level.
     * @param level logging level
     */
    public static function setLevel(level: Level) {
        trace('setLevel $level');
        _globalLevel = levelNum(level);
    }

    /**
     * Sets logger maximum logging level.
     * @param logger logger name
     * @param level logging level
     */
    public static function setLoggerLevel(logger: String, level: Level) {
        trace('setLoggerLevel $logger $level');
        _globalLevel = levelNum(level);
    }

    /**
     * Don't call directly
     *
     * @param configStr
     * @param configFileName
     */
    public static function _init(?configStr: String, ?configFileName: String) {
        var t = Meta.getType(alogging.meta.MetaHolder);
        if (Reflect.hasField(t, 'loggerLevel')) {
            loggerLevel = Unserializer.run(t.loggerLevel[0]);
        }
        if (Reflect.hasField(t, 'loggerName2Num')) {
            loggerName2Num = Unserializer.run(t.loggerName2Num[0]);
        }
    }

    /**
     * Informs the logging system to perform an orderly shutdown by flushing and closing all handlers.
     * This should be called at application exit and no further use of the logging system should be made after this call.
     */
    public static function shutdown() {

    }

    /// to be used from generated code
    public static var _globalLevel: Int = 0;
    public static var handlerLevel: Map<Int, Int> = new Map();
    public static var loggerLevel: Map<Int, Int> = new Map();
    public static var loggerName2Num: Map<String, Int> = new Map();

#end

    /// implementation

    static function levelNum(level: Level): Int {
        return switch (level ) {
            case SEVERE:  70;
            case WARNING: 60;
            case INFO:    50;
            case CONFIG:  40;
            case FINE:    30;
            case FINER:   20;
            case FINEST:  10;
            default:       0;
        }
    }

    #if macro
    public static var loggerName2Num: Map<String, Int> = new Map();
//    public static var loggers: Map<Int, Int> = new Map();
    public static var ctHandlerLevel: Map<Int, Int> = new Map();
    static var nextLoggerNum = 1;
    /// all
    static var compileTimeGlobalLevel: Int = 0;
    static var initialized = false;
    static var nonRootLoggersUsed = false;
    static var runtimeInitCalled = false;

    static function log(level: Level, loggerOrMessage: Expr, message: Expr) {
        initialize();
//        trace(loggerOrMessage);

        var logger: String = null;
        var secondIsNull = false;

        switch (loggerOrMessage.expr) {
            case EConst(CString(cstr)):
                logger = cstr;
            default:
        }

        switch (message.expr) {
            case EConst(CIdent('null')):
                secondIsNull = true;
            default:
        }

        if (!secondIsNull && logger == null) {
            Context.error('First parameter must be logger name, identified by constant string', Context.currentPos());
        }
        if (secondIsNull) {
            message = loggerOrMessage;
            logger = 'ROOT';
        }

        var rmess = secondIsNull ? loggerOrMessage : message;
        return intLog(level, logger, rmess);
    }

    static function intLog(level: Level, logger: String, message: Expr) {
//        trace('level: $level, logger: $logger, message: $message');
        if (!loggerName2Num.exists(logger)) {
            loggerName2Num.set(logger, nextLoggerNum);
            nextLoggerNum += 1;
        }
        var loggerNum = loggerName2Num.get(logger);
        var levelNum = Logging.levelNum(level);

        var handleCode;
        if (Context.defined('js')) {
            handleCode = JSConsoleHandler.handle(level, logger, message);
        } else {
            handleCode = TraceHandler.handle(level, logger, message);
        }
        if (logger != 'ROOT') {
            nonRootLoggersUsed = true;
            // check loggers level
            handleCode = macro { if ($v{levelNum} >= alogging.Logging.loggerLevel.get($v{loggerNum}) ) { $handleCode; } };
        }
        return macro { if ($v{levelNum} >= alogging.Logging._globalLevel) { $handleCode; } }
//        return macro { trace('$logger - $loggerNum - ' + $e{message}); }
    }

    static function initStaticVars() {
        loggerName2Num= new Map();
    //    public static var loggers: Map<Int, Int> = new Map();
        ctHandlerLevel = new Map();
        nextLoggerNum = 1;
        /// all
        compileTimeGlobalLevel = 0;
        initialized = false;
        nonRootLoggersUsed = false;
        runtimeInitCalled = false;
    }

    static function initialize() {
        if (!initialized) {
            loggerName2Num.set('ROOT', 0);
            initialized = true;
//            trace(Context.getDefines());
            Context.onAfterGenerate(function() {
//                trace('onAfterGenerate');
                if (!runtimeInitCalled && nonRootLoggersUsed) {
                    Context.error('If you use non-root loggers, then you must call Logging.init function to initialize logging system properly.', Context.currentPos());
                }
            });
            Context.onGenerate(function(types) {
//                trace('onGenerate');
                if (!runtimeInitCalled && nonRootLoggersUsed) {
                    Context.error('If you use non-root loggers, then you must call Logging.init function to initialize logging system properly.', Context.currentPos());
                }


                if (nonRootLoggersUsed) {
                    var _loggerLevel = new Map<Int, Int>();
//                    var serializer = new Serializer();
//                    serializer.serialize(loggerName2Num);
//                    var s = serializer.toString();
//                    trace(s); // y3:fooi12

                    for (loggerName in loggerName2Num.keys()) {
                        if (loggerName != 'ROOT') {
                            _loggerLevel.set(loggerName2Num.get(loggerName), levelNum(FINEST));
                        }
                    }

    //                trace(types);
                    for (t in types) {
    //                    trace(t);
                        switch (t) {
                            case TInst(t, params):
                                var ct = t.get();
                                if (ct.module == 'alogging.meta.MetaHolder') {
                                   trace('COOL!');
                                   trace(ct.meta.has('initCalled'));
                                   if (ct.meta.has('loggerLevel')) {
                                       ct.meta.remove('loggerLevel');
                                   }
                                   ct.meta.add('loggerLevel', [ macro $v { Serializer.run(_loggerLevel) } ], Context.currentPos());
                                   if (ct.meta.has('loggerName2Num')) {
                                       ct.meta.remove('loggerName2Num');
                                   }
                                   ct.meta.add('loggerName2Num', [ macro $v { Serializer.run(loggerName2Num) } ], Context.currentPos());
                                }
    //                            switch (ct) {
    //                                case { name : 'MetaHolder' } :
    //                                   trace('COOL!');
    //                                   trace(ct);
    //                                default:
    //                            }
    //                            trace(t.get().name);
                            default:

                        }
                    }
                }

            });
            Context.onMacroContextReused(function() {
//                trace('----- macro reused');
//                initStaticVars();
//                nonRootLoggersUsed = false;
//                runtimeInitCalled = false;
//                return true;
                return false;
            });
        }
    }

    #end

}
