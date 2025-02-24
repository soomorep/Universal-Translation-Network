;; Translation Algorithm Contract

(define-data-var next-model-id uint u0)

(define-map translation-models
  { model-id: uint }
  {
    source-language: (string-ascii 64),
    target-language: (string-ascii 64),
    accuracy: uint,
    version: uint
  }
)

(define-public (register-translation-model (source-language (string-ascii 64)) (target-language (string-ascii 64)) (accuracy uint))
  (let
    ((model-id (+ (var-get next-model-id) u1)))
    (var-set next-model-id model-id)
    (ok (map-set translation-models
      { model-id: model-id }
      {
        source-language: source-language,
        target-language: target-language,
        accuracy: accuracy,
        version: u1
      }
    ))
  )
)

(define-public (update-model-accuracy (model-id uint) (new-accuracy uint))
  (let
    ((model (unwrap! (map-get? translation-models { model-id: model-id }) (err u404))))
    (ok (map-set translation-models
      { model-id: model-id }
      (merge model {
        accuracy: new-accuracy,
        version: (+ (get version model) u1)
      })
    ))
  )
)

(define-read-only (get-translation-model (model-id uint))
  (map-get? translation-models { model-id: model-id })
)

