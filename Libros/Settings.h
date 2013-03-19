// File to define CHANGEABLE settings (like endpoints) and debug flags

//#define API_ENDPOINT @"http://narwhal.local:3000"
#define API_ENDPOINT @"http://librosapp.tk"

//#define IAP_SKIP YES
#define IAP_SKIP NO

#ifdef DEBUG
// sean's github
#define PARSE_MODE @"dev = github/seanhess"
#define PARSE_APP_ID @"eExCZu0ZMKPf5HiVnOZOYj0YwU2fKke5oqJFFNGw"
#define PARSE_CLIENT_KEY @"oiS6wmrGYgiQDsVV1m1s7ud7M5ydq3fq14h26xM8"
#else
// espanolLibros@gmail.com / EspanolLibros3
#define PARSE_MODE @"prod = espanolLibros@gmail.com"
#define PARSE_APP_ID @"FPZGFXVlfPH1NYZ59uU1IppkSlAHZH3hhZRIqLaT"
#define PARSE_CLIENT_KEY @"mCabeZDzREBI1lqNvpnInpkgiEBOf0C6ZqXW2bdP"
#endif
