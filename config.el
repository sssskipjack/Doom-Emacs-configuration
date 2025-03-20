;; -----------------------
;; User Info
;; -----------------------
(setq user-full-name "Jack Zheng"
      user-mail-address "jack.zheng.nz@gmail.com")

;; -----------------------
;; UI Settings
;; -----------------------
(setq doom-theme 'doom-one
      display-line-numbers-type t)

;; -----------------------
;; Org Directory
;; -----------------------
(setq org-directory "~/org"
      org-roam-directory (expand-file-name "roam" org-directory)
      org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory))

;; -----------------------
;; Org Agenda
;; -----------------------
(setq org-agenda-files (list "~/org/todo/"))

;; -----------------------
;; Org-Roam Configuration
;; -----------------------
(use-package! org-roam
  :init
  (setq org-roam-completion-everywhere t
        ;; All literature-review templates have been removed below:
        org-roam-capture-templates
        '(
          ;; Fleeting Note Template
          ("f" "Fleeting Note" plain
           "* ${title}\n\n%?"
           :target (file+head "fleeting/${slug}.org" "#+title: ${title}\n#+filetags: :fleeting:\n")
           :unnarrowed t)

          ;; Permanent Note Template
          ("p" "Permanent Note" plain
           "* ${title}\n\n%?"
           :target (file+head "permanent/${slug}.org" "#+title: ${title}\n#+filetags: :permanent:\n")
           :unnarrowed t)
          ))
  :config
  (org-roam-db-autosync-mode))

;; -----------------------
;; Org-Roam-UI
;; -----------------------
(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;; -----------------------
;; Citar (Bibliography Management)
;; -----------------------
(use-package! citar
  :after org
  :custom
  (citar-bibliography (,(expand-file-name "bibtex/Honours.bib" org-directory)))
  (citar-notes-paths (,(expand-file-name "roam/honours" org-roam-directory)))
  (citar-library-paths (,(expand-file-name "bibtex/pdfs/" org-directory)))
  :bind
  (:map doom-leader-map
        ("n c" . citar-insert-citation)))

;; -----------------------
;; Org-Cite Configuration
;; -----------------------
(setq org-cite-global-bibliography (list (expand-file-name "bibtex/Honours.bib" org-directory)))

;; -----------------------
;; Date/Time Formatting
;; -----------------------
(setq org-time-stamp-formats '("<%d/%m/%Y>" . "<%d/%m/%Y %H:%M>"))

;; -----------------------
;; Keybindings
;; -----------------------
(map! :leader
      (:prefix "o"
       :desc "Toggle Neotree" "p" #'neotree-toggle
       :desc "Org-Roam Capture" "r" #'org-roam-capture
       :desc "Open Org-Roam UI" "u" #'org-roam-ui-open)

      (:prefix "n"
       (:prefix ("r" . "Org-Roam")
        :desc "Find/create node" "f" #'org-roam-node-find
        :desc "Insert link to node" "i" #'org-roam-node-insert
        :desc "Capture note" "c" #'org-roam-capture
        :desc "Toggle backlinks buffer" "b" #'org-roam-buffer-toggle
        :desc "Open today's daily note" "d" #'org-roam-dailies-goto-today
        :desc "Capture today's daily note" "D" #'org-roam-dailies-capture-today))

      (:prefix "i"
       :desc "Insert Citation" "c" #'citar-insert-citation
       :desc "Insert Date" "d" #'org-time-stamp))

;; -----------------------
;; Neotree: Show Hidden Files
;; -----------------------
(setq-default neo-show-hidden-files t)
;; -----------------------
;; AUCTeX Setup for LaTeX Editing
;; -----------------------
(use-package! tex
  :defer t
  :hook ((LaTeX-mode . TeX-PDF-mode)      ;; Enable PDF mode for LaTeX
         (LaTeX-mode . TeX-source-correlate-mode) ;; SyncTeX support
         (LaTeX-mode . flyspell-mode)     ;; Enable spell check
         (LaTeX-mode . reftex-mode))      ;; Enable RefTeX for citations
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-save-query nil
        TeX-source-correlate-start-server t ;; For PDF syncing
        TeX-engine 'pdflatex))

;; -----------------------
;; Set Default LaTeX Compiler
;; -----------------------
(setq TeX-command-default "LatexMk")
(setq TeX-engine 'pdflatex)  ;; Options: pdflatex, xetex, lualatex

;; -----------------------
;; Org-Mode LaTeX Export Configuration
;; -----------------------
(setq org-latex-compiler "pdflatex")

;; -----------------------
;; Auto Refresh PDF on Compilation
;; -----------------------
(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
