/* REQUIRE */
var express = require('express');
var expressValidator = require('express-validator');
var admin = require('./routes/admin-routes');



/* EXPRESS */
var app = express();
// app.use(express.static('public'));
app.use(express.static(__dirname + '/public'));
// app.use(express.static(__dirname + '/'));

/* COOKIES */
var cookieParser = require('cookie-parser');
var session = require('express-session');
app.use(cookieParser());
app.use(session({
    secret: "Instasolve Admin Login Secrets",
    resave: true,
    saveUninitialized: true
}));

/* EJS */
app.set("view engine", "ejs");

var bodyParser = require('body-parser');
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: true}))
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
		res.redirect("/login");
	}

};

sessionCheck = function(req, res, next){
	console.log("Cookie Parser: ", req.cookies);
	console.log("Session: ", req.session);
	console.log("Session Email: ",req.session.email);
	if (req.body) {
    console.log('LOG:',req.method,req.url,req.body)
  	}
  	if (!(req.session.email)){
  		console.log("Session invalid: please login");
  		// redirect()
  	}
  	console.log("=========================================");
  	next()
}

// Start the server
app.listen(3000);

/* SESSION MIDDLEWARE */
app.use(sessionCheck)


/* EXPRESS GET & POST */
app.get('/', function(req, res) {
	if (req.session.email){
		res.redirect('/main');
	} else {
		res.redirect('/login');
	}
});

app.get('/login', function(req, res){
	res.render("login");
});

app.get('/verify', verify);

app.get('/main', main);

app.get('/setting', function(req, res){
	res.render('/setting');
});

app.get('/addtutor', function(req, res){
	console.log("request to add tutor");
	if (req.session.email){
		res.render('addtutor');
	} else {
		res.redirect('/login');
	}
});

app.get('/user', function(req, res){
	console.log("request to find user");
	if (req.session.email){
		res.render('user');
	} else {
		res.redirect('/login');
	}
});

app.get('/logout', function(req, res){
	console.log("logout");
	console.log(req.session);
    req.session.destroy(function(err){
        if(err){
            console.log("ERROR accurred: " + err);
        }else{
            res.redirect('/login');
        }
    });
});


// app.post('/comfirmAddTutor', admin.addtutor);
app.post('/comfirmAddTutor', admin.addtutor);


console.log('Listening on port 3000');


































