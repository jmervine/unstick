package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/joeshaw/envdecode"
)

type configs struct {
	CookieName string `env:"COOKIE_NAME,required"`
	Redirect   string `env:"REDIRECT"`
	Port       string `env:"PORT,default=8000"`
	Bind       string `env:"BIND,default=127.0.0.1"`
	ServerKey  string `env:"SERVER_KEY"`
	ServerCrt  string `env:"SERVER_CRT"`
	Debug      bool   `env:"DEBUG,default=false"`
}

func (c *configs) useSSL() bool {
	return c.Port == "443" && c.ServerKey != "" && c.ServerCrt != ""
}

func main() {
	c := configs{}
	if err := envdecode.Decode(&c); err != nil {
		log.Fatal(err)
	}

	if c.Debug {
		log.Printf("%+v\n", c)
	}

	act := func(w http.ResponseWriter, r *http.Request) {
		var cookie, err = r.Cookie(c.CookieName)

		respond := func(s int, o string) {
			w.WriteHeader(s)
			w.Write([]byte(o))
			log.Println(o)
		}

		if err != nil {
			respond(http.StatusNotFound, fmt.Sprintf("%d - %v: %s\n", http.StatusNotFound, err, c.CookieName))
			return
		}

		cookie.MaxAge = -1
		http.SetCookie(w, cookie)

		if c.Redirect != "" {
			http.Redirect(w, r, c.Redirect, http.StatusSeeOther)
			log.Println("Redirecting to " + c.Redirect)
			return
		}

		respond(http.StatusOK, fmt.Sprintf("%d - deleted: %s\n", http.StatusOK, c.CookieName))
	}

	http.HandleFunc("/unstick", act)

	l := fmt.Sprintf("%s:%s", c.Bind, c.Port)
	log.Printf("Listening on '%s', cookie=%s\n", l, c.CookieName)

	if c.useSSL() {
		log.Fatal(http.ListenAndServeTLS(l, c.ServerCrt, c.ServerKey, nil))
	} else {
		log.Fatal(http.ListenAndServe(l, nil))
	}
}
