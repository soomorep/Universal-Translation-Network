;; Language Analysis Contract

(define-data-var next-analysis-id uint u0)

(define-map language-analyses
  { analysis-id: uint }
  {
    language: (string-ascii 64),
    communication-type: (string-ascii 20),
    complexity: uint,
    status: (string-ascii 20)
  }
)

(define-public (analyze-language (language (string-ascii 64)) (communication-type (string-ascii 20)) (complexity uint))
  (let
    ((analysis-id (+ (var-get next-analysis-id) u1)))
    (var-set next-analysis-id analysis-id)
    (ok (map-set language-analyses
      { analysis-id: analysis-id }
      {
        language: language,
        communication-type: communication-type,
        complexity: complexity,
        status: "pending"
      }
    ))
  )
)

(define-public (update-analysis-status (analysis-id uint) (new-status (string-ascii 20)))
  (let
    ((analysis (unwrap! (map-get? language-analyses { analysis-id: analysis-id }) (err u404))))
    (ok (map-set language-analyses
      { analysis-id: analysis-id }
      (merge analysis { status: new-status })
    ))
  )
)

(define-read-only (get-language-analysis (analysis-id uint))
  (map-get? language-analyses { analysis-id: analysis-id })
)

