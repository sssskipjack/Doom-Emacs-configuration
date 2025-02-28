;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; User Info
(setq user-full-name "Jack Zheng"
      user-mail-address "jack.zheng.nz@gmail.com")

;; UI Settings
(setq doom-theme 'doom-one
      display-line-numbers-type t)

;; Org Directory
(setq org-directory "~/org"
      org-roam-directory (expand-file-name "roam" org-directory)
      org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory))

;; Org agenda
(setq org-agenda-files (list "~/org/todo/"))

;; Org-Roam Configuration
(use-package! org-roam
  :init
  (setq org-roam-completion-everywhere t
        org-roam-capture-templates
        '(

          ;; Template for Review Papers
          ("1" "Literature Review (Review Paper)" plain
           "#+date: %t
* Research Focus
** Title:
** Authors/Year:

* Scope & Objectives
[Outline the scope and aims of the review]

* Key Themes
[What are the main themes and contributions?]

* Critical Analysis
[Your evaluation and insights]

* Identified Gaps
[Overarching research gaps identified across the literature]

* Future Directions
[Suggestions for further research]

* References
[Insert citation metadata, e.g., Author, Year, etc.]
"
           :target (file+head "literature/${slug}.org" "#+title: ${title}\n#+filetags: :literature:1:\n")
           :unnarrowed t)

          ;; Template for Technical Papers
          ("2" "Literature Review (Technical Paper)" plain
           "#+date: %t
* Research Focus
** Title:
** Authors/Year:

* Context & Problem Statement
[Describe the real-world problem]

* Research Gaps & Questions
[Identify gaps and key questions]

* Methods & Data
** Data:
** Techniques:

* Key Findings
[Summarize key results or metrics]

* Insights & Implications
[Preliminary findings and policy implications]

* Miscellaneous
[Notes from meetings, e.g., Hao Wang]

* References
[Insert citation metadata, e.g., Author, Year, etc.]
"
           :target (file+head "literature/${slug}.org" "#+title: ${title}\n#+filetags: :literature:2:\n")
           :unnarrowed t)

          ;; Template for Tool Papers
          ("3" "Literature Review (Tool Paper)" plain
           "#+date: %t
* Tool Overview
** Name:
** Version/Release:

* Purpose & Application
[Describe the key purpose and how the tool is applied in practice]

* Features & Capabilities
[Detail the key features]

* Evaluation
[Assess the tool’s strengths, limitations, and note any integration/compatibility challenges]

* Integration in Research
[How the tool fits into broader research contexts]

* References
[Insert citation metadata, e.g., Author, Year, etc.]
"
           :target (file+head "literature/${slug}.org" "#+title: ${title}\n#+filetags: :literature:3:\n")
           :unnarrowed t)

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


;; Org-Roam-UI
(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;; Citar (Bibliography Management)
(use-package! citar
  :after org
  :custom
  (citar-bibliography `(,(expand-file-name "bibtex/Honours.bib" org-directory)))
  (citar-notes-paths `(,(expand-file-name "roam/honours" org-roam-directory)))
  (citar-library-paths `(,(expand-file-name "bibtex/pdfs/" org-directory)))
  :bind
  (:map doom-leader-map
        ("n c" . citar-insert-citation)))

;; Org-Cite Configuration
(setq org-cite-global-bibliography `(,(expand-file-name "bibtex/Honours.bib" org-directory))
      org-cite-insert-processor 'citar
      org-cite-follow-processor 'citar
      org-cite-activate-processor 'citar)

(setq org-time-stamp-formats '("<%d/%m/%Y>" . "<%d/%m/%Y %H:%M>"))

;; anki
(use-package! anki-editor
  :after org
  :config
  (setq anki-editor-create-decks t))

;; Keybindings
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

;; Show Hidden Files in Neotree
(setq-default neo-show-hidden-files t)
