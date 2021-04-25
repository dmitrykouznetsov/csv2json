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
        [dqtwidgets [MainWindowTemplate h-layout v-layout EditableTree EditableList add-action]]
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


(defn bind-actions [widget actions]
  (for [(, entry action) (actions.items)]
    (add-action widget entry action)))


(defn gui []
  (setv input-list (EditableList)
        list-actions {"Load CSV" (fn [x] (x.populate (load-csv)))
                      "Clear list" (fn [x] (x.clear))}
        output-tree (EditableTree)
        tree-actions {"Save to JSON" (fn [x] (store x.items))
                      "Add Entry" (fn [x] (x.add-entry))}
        content (h-layout [input-list output-tree] :spacing 10 :margin 10))

  ; The actions must be bound separately due to Qt internals
  (bind-actions input-list list-actions)
  (bind-actions output-tree tree-actions)

  (MainWindowTemplate :domain "com.github.dmitrykouznetsov"
                      :appname "csv2json"
                      :centralwidget content))


(defmain [&rest _]
  (setv app (QApplication sys.argv)
        mainwindow (gui))
  ; Important to set syle to Fusion to get the colors correct on Windows!
  (app.setStyle "Fusion")
  (.show mainwindow)
  (sys.exit (app.exec_)))
