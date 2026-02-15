(setq user-full-name "Johnny Alejandro Rojas"
      user-mail-address "johnny.rojas.me@gmail.com")

(add-to-list 'load-path "~/.config/doom/org-preview") ;; path to org-preview.el
(require 'org-preview)

(setq doom-font (font-spec :family "Fira Code Nerd Font")
      doom-variable-pitch-font (font-spec :family "Fira Code Nerd Font"))

(setq doom-theme 'ef-day)

(setq display-line-numbers-type 'relative)

(setq org-directory "~/org/")

(setq-default fill-column 80)

;; (dolist (hook '(text-mode-hook org-mode-hook LaTeX-mode-hook))
;;   (add-hook hook #'auto-fill-mode))

(after! evil
  (setq evil-default-state 'emacs))

;; This line of code makes the module availiable
(use-package! visual-fill-column)

(defun my-centered-buffer () ;; Makes A Text Buffer Centered Layout
  (setq visual-fill-column-width 90
        visual-fill-column-center-text t)

  (visual-fill-column-mode 1) ;; Enables Column Mode
  (visual-line-mode 1)) ;; Enables Wrapping

;; Apply layout to Org and LaTeX buffers
(add-hook 'org-mode-hook #'my-centered-buffer)
(add-hook 'LaTeX-mode-hook #'my-centered-buffer)

(after! xenops
  (setq xenops-math-image-scale-factor 1.6
        xenops-reveal-on-entry nil)
  (add-hook 'LaTeX-mode-hook #'xenops-mode))

(after! org
  (setq org-startup-with-latex-preview t
        org-latex-create-formula-image-program 'dvipng
        org-fragtog-latex-delay 0.2)

  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 1.6))

  (setq org-format-latex-options
        (plist-put org-format-latex-options :margin 0.2))

  (add-hook 'org-mode-hook #'org-fragtog-mode))

(defun my-prettify-latex-symbols ()
  "Prettify common LaTeX math symbols."
  (setq prettify-symbols-alist
        '(("\\pi" . ?π)
          ("\\theta" . ?θ)
          ("\\lambda" . ?λ)
          ("\\alpha" . ?α)
          ("\\beta" . ?β)
          ("\\gamma" . ?γ)
          ("\\infty" . ?∞)
          ("\\sum" . ?∑)
          ("\\int" . ?∫)
          ("\\euler" . ?ℯ)
          ("\\phi" . ?φ)
          ("\\epsilon" . ?ε)))
  (prettify-symbols-mode 1))

(add-hook 'org-mode-hook #'my-prettify-latex-symbols)

(defun my-org-mode-faces-setup ()
  "Set up Org headings, title, variable-pitch, and bullets safely per buffer."
  ;; Document title
  (set-face-attribute 'org-document-title nil
                      :family "Latin Modern Roman"
                      :height 2.2
                      :weight 'bold)
  ;; Headline levels
  (let ((base 1.6)
        (step 0.2))
    (dolist (level '(1 2 3 4 5 6 7 8))
      (set-face-attribute (intern (format "org-level-%d" level))
                          nil
                          :family "Latin Modern Roman"
                          :slant 'italic
                          :weight 'bold
                          :height (- base (* (1- level) step)))))
  ;; Fixed-pitch faces in Org
  (setq-local org-variable-pitch-fixed-faces
              '(org-block org-table org-code org-verbatim))
  ;; Indent mode and layout
  (org-indent-mode 1)
  (my-centered-buffer)
  ;; Org Superstar bullets
  (org-superstar-mode 1))

(after! org
  ;; Add per-buffer face setup
  (add-hook 'org-mode-hook #'my-org-mode-faces-setup)

  ;; Setup org-superstar defaults
  (use-package! org-superstar
    :config
    (setq org-superstar-headline-bullets-list '("#" "@" "&" "%")
          org-superstar-item-bullet-alist '((?+ . ?•)
                                            (?- . ?–)
                                            (?* . ?*)))))

(use-package! pdf-tools
  :config
  (pdf-tools-install)
  (setq TeX-view-program-selection
        '((output-pdf "PDF Tools"))
        TeX-source-correlate-start-server t))

(add-hook 'pdf-view-mode-hook #'auto-revert-mode)

(after! smartparens
  (sp-local-pair 'org-mode "$" "$"))

(after! yasnippet
  (dolist (mode '(org-mode LaTeX-mode))
    (yas-define-snippets
     mode
     '(("align"
        "\\begin{align*}\n$0\n\\end{align*}"
        "align*"
        nil nil nil "/align" nil nil)))))
