.local.utc:1b; //1b for UTC, 0b for local
.logger.colourOn: 1b; // toggle coloured logging messages 
.logger.debugOn: 0b
.logger.environment: `dev; 


.logger.init:{[]
     $[.logger.utc;
       [.logger.tz:"UTC";.logger.p:{string .z.p}];
       [.logger.tz:first system"date +%Z";.logger.p:{string .z.P}]
     ];
    // ability toggle debug message on/off to save on resources 
    $[.logger.environment in `dev; .logger.debugOn: 1b];   
 };

.logger.message:{[message; level] 
    banner: "|" sv (string[.logger.p[]], " ",.logger.tz; "process name";      string[level]; string[.z.w]; string[.z.u]; .util.getMemUsed[]; "");
	 : banner, message;
 };

.logger.error:{[message]
	if[.logger.colourOn; 1 "\033[31m"]; //red
	-1 .logger.message[message; `error];
	1 "\033[37m"; //white	
	: message;
 };
 
.logger.warn:{[message]
	if[.logger.colourOn; 1 "\033[33m"];  //yellow
	-1 .logger.message[message; `warn];
	1 "\033[37m"; //white
	: message;
 };

.logger.debug:{[message]
  if[.logger.debugOn; -1 .logger.message[message; `debug]];
	: message;
 };

.logger.info:{[message]
    -1 .logger.message[message; `info];
	: message;
 };

.logger.fatal:{[message]
	if[.logger.colourOn; 1 "\033[31m"]; //red
	-1 .logger.message[message; `fatal];
	1 "\033[37m"; //white
	: message;
 };
 

// example of getting memory usage and formatting
.util.binaryPrefix:{("B";"KB";"MB";"GB";"TB")[i]{y,x}'.Q.f[2] each x%l i:(l:-1 1024,`long$1024 xexp 2 3 4) bin x}
.util.getMemUsed:{"/" sv (.util.binaryPrefix `syms _.Q.w[]) `used`mphy }



