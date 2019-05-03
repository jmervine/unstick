package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/joeshaw/envdecode"
)

type configs struct {
	CookieName string `env:"COOKIE_NAME,required"`
	Redirect   string `env:"REDIRECT,default=/"`
	Port       string `env:"PORT,default=8000"`
	Bind       string `env:"BIND,default=127.0.0.1"`
}

func main() {
	c := configs{}
	if err := envdecode.Decode(&c); err != nil {
		log.Fatal(err)
	}

	act := func(w http.ResponseWriter, r *http.Request) {
		var status int
		var cookie, err = r.Cookie(c.CookieName)
		if err != nil {
			status = http.StatusNotFound
			w.WriteHeader(status)
			w.Write([]byte(fmt.Sprintf("%d - %v: %s\n", status, err, c.CookieName)))
			return
		}

		cookie.MaxAge = -1
		http.SetCookie(w, cookie)

		status = http.StatusOK
		w.WriteHeader(status)
		w.Write([]byte(fmt.Sprintf("%d - deleted: %s\n", status, c.CookieName)))
	}

	http.HandleFunc("/", act)
	http.HandleFunc("/unstick", act)

	l := fmt.Sprintf("%s:%s", c.Bind, c.Port)
	log.Printf("Listening on '%s', cookie=%s\n", l, c.CookieName)
	log.Fatal(http.ListenAndServe(l, nil))
}
