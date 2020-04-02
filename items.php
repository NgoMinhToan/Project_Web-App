<?php
    class Item{
        function __construct($item_index, $title, $view, $date){
            $this->item_index = $item_index;
            $this->title = $title;
            $this->view = $view;
            $this->date = $date;
        }
    }
?>