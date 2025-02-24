;; Cultural Context Contract

(define-data-var next-context-id uint u0)

(define-map cultural-contexts
  { context-id: uint }
  {
    language: (string-ascii 64),
    context-type: (string-ascii 20),
    description: (string-utf8 256),
    importance: uint
  }
)

(define-public (add-cultural-context (language (string-ascii 64)) (context-type (string-ascii 20)) (description (string-utf8 256)) (importance uint))
  (let
    ((context-id (+ (var-get next-context-id) u1)))
    (var-set next-context-id context-id)
    (ok (map-set cultural-contexts
      { context-id: context-id }
      {
        language: language,
        context-type: context-type,
        description: description,
        importance: importance
      }
    ))
  )
)

(define-public (update-context-importance (context-id uint) (new-importance uint))
  (let
    ((context (unwrap! (map-get? cultural-contexts { context-id: context-id }) (err u404))))
    (ok (map-set cultural-contexts
      { context-id: context-id }
      (merge context { importance: new-importance })
    ))
  )
)

(define-read-only (get-cultural-context (context-id uint))
  (map-get? cultural-contexts { context-id: context-id })
)

