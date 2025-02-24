;; Xenolinguistics Adaptation Contract

(define-data-var next-alien-language-id uint u0)

(define-map alien-languages
  { language-id: uint }
  {
    name: (string-ascii 64),
    discovery-date: uint,
    complexity: uint,
    integration-status: (string-ascii 20)
  }
)

(define-public (register-alien-language (name (string-ascii 64)) (complexity uint))
  (let
    ((language-id (+ (var-get next-alien-language-id) u1)))
    (var-set next-alien-language-id language-id)
    (ok (map-set alien-languages
      { language-id: language-id }
      {
        name: name,
        discovery-date: block-height,
        complexity: complexity,
        integration-status: "discovered"
      }
    ))
  )
)

(define-public (update-integration-status (language-id uint) (new-status (string-ascii 20)))
  (let
    ((language (unwrap! (map-get? alien-languages { language-id: language-id }) (err u404))))
    (ok (map-set alien-languages
      { language-id: language-id }
      (merge language { integration-status: new-status })
    ))
  )
)

(define-read-only (get-alien-language (language-id uint))
  (map-get? alien-languages { language-id: language-id })
)

