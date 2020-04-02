<?php
    class Content{
        function __construct($id, $content_index, $item_index, $src, $content, $tag){
            $this->id = $id;
            $this->content_index = $content_index;
            $this->item_index = $item_index;
            $this->src = $src;
            $this->content = $content;
            $this->tag = $tag;
        }
    }
?>