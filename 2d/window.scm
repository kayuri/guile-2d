;;; guile-2d
;;; Copyright (C) 2013 David Thompson <dthompson2@worcester.edu>
;;;
;;; Guile-2d is free software: you can redistribute it and/or modify it
;;; under the terms of the GNU Lesser General Public License as
;;; published by the Free Software Foundation, either version 3 of the
;;; License, or (at your option) any later version.
;;;
;;; Guile-2d is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; Lesser General Public License for more details.
;;;
;;; You should have received a copy of the GNU Lesser General Public
;;; License along with this program.  If not, see
;;; <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Window management.
;;
;;; Code:

(define-module (2d window)
  #:use-module (figl gl)
  #:use-module ((sdl sdl) #:prefix SDL:)
  #:use-module ((sdl mixer) #:prefix SDL:)
  #:use-module (2d vector2)
  #:export (open-window
            close-window))

(define* (open-window title resolution fullscreen)
  "Open the game window with the given TITLE and RESOLUTION. If
FULLSCREEN is #t, open a fullscreen window."
  (let ((flags (if fullscreen '(opengl fullscreen) 'opengl))
        (width (vx resolution))
        (height (vy resolution)))
    ;; Initialize everything
    (SDL:enable-unicode #t)
    (SDL:init 'everything)
    (SDL:open-audio)
    ;; Open SDL window in OpenGL mode.
    (SDL:set-video-mode width height 24 flags)
    (SDL:set-caption title)
    ;; Initialize OpenGL orthographic view
    (gl-viewport 0 0 width height)
    (set-gl-matrix-mode (matrix-mode projection))
    (gl-load-identity)
    (gl-ortho 0 width height 0 -1 1)
    (set-gl-matrix-mode (matrix-mode modelview))
    (gl-load-identity)
    ;; Enable texturing and alpha blending
    (gl-enable (enable-cap texture-2d))
    (gl-enable (enable-cap blend))
    (set-gl-blend-function (blending-factor-src src-alpha)
                           (blending-factor-dest one-minus-src-alpha))))

(define (close-window)
  "Close the game window and audio."
  (SDL:close-audio)
  (SDL:quit))
