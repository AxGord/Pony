package pony.net.http.modules.mmodels;

import pony.text.tpl.ITplPut;

/**
 * @author AxGord <axgord@gmail.com>
 */
interface ISubActionConnect {
  function subtpl(parent:ITplPut, data:Dynamic):ITplPut;
}