sessionStorage.data = null;
var data = {};

function onContinue() {
	data.person = {
		name: $('input[name="name"]').val()
	};
	sessionStorage.data = JSON.stringify(data);
	window.location.replace('pointing.html');
}