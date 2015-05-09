<script>
  function statusChangeCallback(response) {
	if (response.status === 'connected') {
	  var accessToken = response.authResponse.accessToken;
	  window.open('?fbauth='+accessToken, '_self');
	}
  }

  function checkLoginState() {
	FB.getLoginStatus(function(response) {
	  statusChangeCallback(response);
	});
  }

  window.fbAsyncInit = function() {
	  FB.init({
		appId      : '%appid%',
		cookie     : true,
		xfbml      : true,
		version    : 'v2.3'
	  });

	  FB.getLoginStatus(function(response) {
		statusChangeCallback(response);
	  });
  };

  // Load the SDK asynchronously
  (function(d, s, id) {
	var js, fjs = d.getElementsByTagName(s)[0];
	if (d.getElementById(id)) return;
	js = d.createElement(s); js.id = id;
	js.src = "http://connect.facebook.net/en_US/sdk.js";
	fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));

</script>
<fb:login-button scope="public_profile,email" onlogin="checkLoginState();">
</fb:login-button>