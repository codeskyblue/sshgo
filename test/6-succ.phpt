<?php
    file_put_contents("php://stdout", "case name" . __FILE__ . "\n");
    $exitcode = 0;
    file_put_contents("php://stdout", "case will return" . $exitcode . "\n");
    exit($exitcode);
