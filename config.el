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

;; Org-Roam Configuration
(use-package! org-roam
  :init
  (setq org-roam-completion-everywhere t
        org-roam-capture-templates
        '(("l" "Literature Review" plain
           "* Title: ${title}\n\n* Authors: \n\n* Year: \n\n* Summary:\n\n* Research Question:\n\n* Methods:\n\n* Key Findings:\n\n* Limitations:\n\n* How This Relates to My Project:\n\n* Citation: cite:@"
           :target (file+head "literature/${slug}.org" "#+title: ${title}\n#+filetags: :literature:\n")
           :unnarrowed t)

          ("f" "Fleeting Note" plain
           "* ${title}\n\n%?"
           :target (file+head "fleeting/${slug}.org" "#+title: ${title}\n#+filetags: :fleeting:\n")
           :unnarrowed t)

          ("p" "Permanent Note" plain
           "* ${title}\n\n%?"
           :target (file+head "permanent/${slug}.org" "#+title: ${title}\n#+filetags: :permanent:\n")
           :unnarrowed t)))
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
        :desc "Today's daily note" "d" #'org-roam-dailies-goto-today
        :desc "Capture daily note" "D" #'org-roam-dailies-capture-today))

      (:prefix ("n c" . "Citations")
       :desc "Insert Citation" "c" #'citar-insert-citation))

;; Show Hidden Files in Neotree
(setq-default neo-show-hidden-files t)
