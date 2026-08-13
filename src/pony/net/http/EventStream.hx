package pony.net.http;

/**
 * EventStream
 * @author AxGord
 */
#if nodejs
typedef EventStream = pony.net.http.platform.nodejs.EventStream;
#else
#error "EventStream is only for nodejs target."
#end
