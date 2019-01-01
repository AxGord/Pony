package pony.net.http.sn;

/**
 * FB
 * @author AxGord
 */
#if nodejs
typedef FB = pony.net.http.sn.nodejs.FB;
#elseif php
typedef FB = pony.net.http.sn.php.FB;
#end