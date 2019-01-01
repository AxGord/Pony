package pony;

/**
 * Pony NPM
 * @author AxGord <axgord@gmail.com>
 */
#if !macro @:build(pony.magic.builder.NPMBuilder.build()) #end
class NPM implements pony.magic.HasLink {

#if (monaco_editor && electron)

	public static var onigasm(link, never):Dynamic = js.Node.require('onigasm');
	public static var monaco_loader(link, never):Dynamic = js.Node.require('monaco-loader');
	public static var monaco_textmate(link, never):Dynamic = js.Node.require('monaco-textmate');
	public static var monaco_editor_textmate(link, never):Dynamic = js.Node.require('monaco-editor-textmate');

#end

}