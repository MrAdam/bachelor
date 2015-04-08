sessionStorage.data = null;
var data = {};

function onContinue() {
	data.person = {
		reference: $('input[name="reference"]').val(),
		age: $('input[name="age"]').val(),
		gender: $('input[name="gender"]:checked').val(),
		videogames: $('select[name="videogames"]').val(),
		computers: $('select[name="computers"]').val(),
		hand: $('input[name="hand"]:checked').val(),
		device: $('select[name="device"]').val()
	};
	sessionStorage.data = JSON.stringify(data);
	window.location.replace('navigating.html');
}