<script src="//vk.com/js/api/openapi.js" type="text/javascript"></script>
<div id="login_button" onclick="VK.Auth.login(authInfo);"></div>
<script language="javascript">
VK.init({
  apiId: %appid%
});
function authInfo(response) {
  if (response.session) window.open('?vkauth='+response.session.sid, '_self');
}
VK.Auth.getLoginStatus(authInfo);
VK.UI.button('login_button');
</script>