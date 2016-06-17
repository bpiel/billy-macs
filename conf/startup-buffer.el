(setq initial-scratch-message ";;
;;                               ╥▓█▒
;;                             ╓╬███▓─
;;                  ╣█▌╥      ╓▓█╩╚█▓┐           ╥
;;                 ╥▓▌▓▓╥    ╦▓█╨ ╠██┐        ╦╬▓▓╨
;;                 ▓▓┘╚▓█─  ╬█▌   ╚█▓┐    ╓╥╬█▀╨
;;       ╥▄╕       ▓▌  ╠█▓▒▓█╩    ╠██┐ ╓╥▓▓▀╨        ╓▄▄▓▓▒─
;;       ╙▓█▒┐    ╬▓▒  └╫██▓      ╙█▌░▓█▀╨    ╓╥▄▄▓█▓▓▓╨╙└
;;        ╩██▓▄   ▓▓╨   ╙▀╨           └      ╙▀▀██▌│
;;         ╫▓▒╢▓▒ █▒           ╓▄▀▓▓▒            ╩▓▓╦
;;         ╫█▌ ╚▓▓▓░    ┌▒▒ ╥╬▓▓▀╙└                ╚█▓╦
;;    ╥    ╠█▓  └▀╨─  ╓╬▓╨╦▓█╩└                      ╫█▒─
;;   ╚▓█   ╠█▓       ╟▓▀   ╙                          ╙█▓╕
;;    ╙█▓░ ╫█▌                     ┌      ╫▓▓╥         ╙╣█╦╥╥
;; ╓▄   █▓╦╙╙                     ╖█▓▓    ╙╫██╥          ╨█▓▓▓╦
;; ╙▀▓▒╥└▀▒                       └▓██▒  ╓╥▄╫▓▒           ▓▓▄▓▌
;;    ╚▓▄┐                          ╩▓▀┴└▀▀╙└║▓▓           ╣█▌┘
;;   ╥▄▓▓┴                                  ╓▄█▌        ╓╥╥╓▓▌─
;;  ┌▀╩▒▄┬                                ╚╬▓╩╙    ╥▄▄▓███▀░╫▓┘
;;   ╬▓▓╨▄╥                                 ╓▄▄▄▓███████▓╨ ▒▓▌
;;   ╙│╦▓▌╨╟▓▓▓▓▓▓▒─                  ╓╓▄▓▓████████████╨  ╬▓▀
;;     ╨╨   ╔╬█╩╨└              ╓╥▄▓▓███▓▓██████████▓╨  ▄▓▒┘
;;         ╥▓▓              ▒▓███████▌╙    ╙▓█████▓╙ ╓▄▓▀╨
;;         ╙▓▓              └╙╨▀▓████▄    ╓▄████╨└ ╓╬▓▀
;;          └╢▓▓╗▄╥╥▄▄▄▓▓▓▒╗       ╙╨╫╬╣▓▓██▓╨╙╓╥╬▓▓▒╥╥
;;             ╙╙╚╩╩╨╙╙╙└ ╙▀▀▓▓▄╥┌          ╥▄▓▓╢╟▓▌║▓█╫▓▓▒▄▄┐   ▄▓▀▀▒╥
;;                            ╙╚╣▓▓▒▒▄╥╥▄╬▓╩╣▒▒▓▓██▌╫▓▒╚▓▒╙▓█▓▒▒▓▀╨  ╫▒
;;                           ╓╗▓▓▓█▒╨╙╨╫╫▒▓▓▓▀╨╙ ╩╫░╣▓ ╠▓░╥▓█▌  └    ╫▓╕
;;                       ╓▄▓▓▒╨╢▓▒╙█▓▓▓▀▀╨╙  ╓▄▄▓▓▓▓█▒┌▓▓░▓╫▓▓▄╥      ╙╫▒┐
;;             ╓┌     ╦╬╣██▒▓▓▒ ╫▓▒╠█▌╥╥▄▄▓▓▓▓▀╨╨░╓▓█▄╠█▒─█▓╫▒╫▌     ╥╥╣▓▒
;;          ╓▒▓╩╬▓╥╥╥╫█▓▄╙╫█╦║▓▒┌║█▒╠█▓╫║╫▄▄▄▓▓▓▓▓▓▓▓▓╨▀╫▓██▓▒╫▒┌▒╥  ╫▓▀└
;;          ╨╫▒  ╙╫▀╨└ ╙▓▓▄╙▓▒╙╫▌╥╠█▓▓▓▀▀▀▀╨╙╙╙░╓╓╥▄╬▓▒    ╙└ ╩▓▓▓▓▄▄▓▒
;;           ╙▓▒─     ▒▒╨║██▒▓▓▄▓█▌▀▓▒▄▄╬▓▓▓▓▓▓▓▓▓▓▀▀▓█           ╙╢▀╨
;;          ╥▓▓└      ╚╫▒  ╙▓▓█▀╙   ╫█▀╙╙╙╙└╓╓╓╥╥╥╥▄╥╬█▒
;;         ╓╣▓     ░╣▄┌╫█    └      ╚█▓▓▓▓▓▓▓▓▓▓▀▀▀▀╨╨║█░
;;          ╠╫▒▓▒  ╥╫▒╩╣╨           ╫█░               ▐█▒
;;             ╙╫▓▓▓╩         ╥╥    ╫█▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓┐
")

(setq inhibit-startup-screen t)