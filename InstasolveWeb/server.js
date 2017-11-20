/* REQUIRE */
var express = require('express');
var expressValidator = require('express-validator');

/* EXPRESS */
var app = express();
// app.use(express.static('public'));
app.use(express.static(__dirname + '/public'));
// app.use(express.static(__dirname + '/'));

/* COOKIES */
var cookieParser = require('cookie-parser');
var session = require('cookie-session');
app.use(cookieParser());
app.use(session({
    secret: "Instasolve Admin Login Secrets"
}));

/* EJS */
app.set("view engine", "ejs");


/* We have to create custom validators:
 * Notice that customValidators is an object with methods defined for
 * each of the inputs we want to validate separately. */
app.use(expressValidator({
    customValidators: {

	isZipcode: function(value) {
		return value.search( /[A-Za-z][0-9][A-Za-z] [0-9][A-Za-z][0-9]/ ) !== -1;
        },
	isSkills: function(value) {
		if (value.search( /^[0-9a-zA-Z ]{1,20}(,[0-9a-zA-Z ]{1,20})*$/ ) !== -1) {
			var array = value.split(',');
			var noEmptyValue = true;
			array.forEach(function(part, index, theArray) {
				theArray[index] = theArray[index].trim();
				console.log("Length: "+ theArray[index].length);
				if (theArray[index].length < 1) {
					noEmptyValue = false;
					return;
				}
			});
			return noEmptyValue;
		}
		else {
			return false;
		}
        }
        
    }
})); // This line must be immediately after express.bodyParser()!

/* USER */
var user = {
    email: "admin@instasolve.ca",
    password: "123456"
};

/* FUNCTIONS */
verify = function(req, res){
	console.log("============= verifying user =================");
	var verifyEmail = req.query.email;
	var verifyPwd = req.query.password;

	if (verifyEmail == user.email){
		if (verifyPwd == user.password){
			req.session.email = verifyEmail;
			return res.redirect('/main');
		} else {
			return res.send("wrongPwd");
		}
	} else {
		return res.send("invalidEmail");
	}
};

main = function(req,res){
	console.log("====verifying section ====");
	if(req.session.email){
		console.log("=== Valid session: Logging in === ");
		res.render("main");
	} else {
		console.log("=== Invalid session: User need to login === ");
		res.render("login");
	}

};


/* EXPRESS GET & POST */
app.get('/', function(req, res) {
	res.redirect('/login');
});

app.get('/login', function(req, res){
	res.render("login");
});

app.get('/verify', verify);


app.get('/main', main);



// Start the server
app.listen(3000);
console.log('Listening on port 3000');

































