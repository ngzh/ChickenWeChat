;; access-token handler
;; https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=APPID&secret=APPSECRET
(include "utils")
(use http-client json) (use dissector)

(define fetch-access-token
  (lambda ()
    (let* ([appid       "wx8c09c17db05adc8b"]
           [appsecret   "225e3b8b6f2b6614f6bca0607dfd2e78"]
           [req-url     (string-append "https://api.weixin.qq.com/cgi-bin/token?"
                                       "grant_type=client_credential" "&"
                                       "appid=" appid "&" "secret=" appsecret)])
      (with-input-from-string (with-input-from-request req-url #f read-string)
        (lambda ()
          (let ([appsecret (json-read)])
            (cdr (vector-ref appsecret 0))))))))

(define get-access-token
  (let ([access-token #f] [last-fetch-time 0.0])
    (lambda ()
      (log "Getting token. last-fetch-time ~A" (string<-seconds (last-fetch-time)))
      (when (> (- (current-seconds) last-fetch-time)
               7100) (log "Got to get a NEW token!")
        (set! access-token (fetch-access-token))
        (set! last-fetch-time (current-seconds)))
      access-token)))
