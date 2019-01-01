package pony.net.http;

/**
 * HttpServer
 * @author AxGord
 */
#if nodejs
typedef HttpServer = pony.net.http.platform.nodejs.HttpServer;
#elseif php
typedef HttpServer = pony.net.http.platform.php.HttpServer;
#else
#error "HttpServer are only for nodejs or php target."
#end