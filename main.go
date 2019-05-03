package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/joeshaw/envdecode"
)

type configs struct {
	CookieName []string `env:"COOKIE_NAME,required"`
	Redirect   string   `env:"REDIRECT"`
	Port       string   `env:"PORT,default=8000"`
	Bind       string   `env:"BIND,default=127.0.0.1"`
	ServerKey  string   `env:"SERVER_KEY"`
	ServerCrt  string   `env:"SERVER_CRT"`
	UseSSL     bool     `env:"USE_SSL,default=false"`
	Debug      bool     `env:"DEBUG,default=false"`
}

func (c *configs) useSSL() bool {
	return c.UseSSL && c.ServerKey != "" && c.ServerCrt != ""
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
		var reset int
		for _, cookieName := range c.CookieName {
			var cookie, err = r.Cookie(cookieName)
			if err == nil {
				if c.Debug {
					log.Printf("BEFORE: %+v\n", cookie)
				}
				cookie.MaxAge = -1
				cookie.Value = ""
				http.SetCookie(w, cookie)
				reset = reset + 1
				if c.Debug {
					log.Printf("AFTER: %+v\n", cookie)
				}
			}
		}

		if c.Redirect != "" {
			http.Redirect(w, r, c.Redirect, http.StatusSeeOther)
			log.Printf("Redirecting to '%s' after resetting %d cookies.\n", c.Redirect, reset)
			return
		}

		w.WriteHeader(http.StatusOK)

		o := fmt.Sprintf("%d - deleted %d cookies\n", http.StatusOK, reset)
		w.Write([]byte(o))
		log.Println(o)
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
