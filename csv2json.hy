; Copyright 2021 Dmitry Kouznetsov <dmitry.kouznetsov@protonmail.com>
;
; This program is free software: you can redistribute it
; and/or modify it under the terms of the GNU General Public License as
; published by the Free Software Foundation, either version 3 of the
; License, or (at your option) any later version.
;
; This program is distributed in the hope that it will be
; useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
; Public License for more details.
;
; You should have received a copy of the GNU General Public License along
; with this program. If not, see http://www.gnu.org/licenses/.
;
(import sys
        csv
        json
        [dqtwidgets [MainWindowTemplate h-layout v-layout EditableTree EditableList]]
        [PySide2.QtWidgets [QApplication QPushButton QFileDialog]])


(defn get-colnames [csv-file]
  (with [f (open csv-file)]
    ; The colnames are the first item of the reader iterable
    (next (csv.reader f))))


(defn load-csv []
  (setv f (first (QFileDialog.getOpenFileName None "Open CSV" "" "(*.csv)")))
  (get-colnames f))

(defn store [data]
  (setv f (first (QFileDialog.getSaveFileName None "Save JSON" "test.json" "(*.json)")))
  (with [w (open f "w")]
    (json.dump data w :indent 4)))


(defn gui []
  (setv input-list (EditableList :actions {"Load CSV" (fn [l] (l.populate (load-csv)))})
                                           ; "Clear list" (fn [l] (l.clear))})
        output-tree (EditableTree :actions {"Save to JSON" (fn [tree] (store tree.items))})
        content (h-layout [input-list output-tree]))

  (MainWindowTemplate :domain "com.github.dmitrykouznetsov" :appname "csv2json"
                      :centralwidget content))


(defmain [&rest _]
  (setv app (QApplication sys.argv)
        mainwindow (gui))
  ; Important to set syle to Fusion to get the colors correct on Windows!
  (app.setStyle "Fusion")
  (.show mainwindow)
  (sys.exit (app.exec_)))
