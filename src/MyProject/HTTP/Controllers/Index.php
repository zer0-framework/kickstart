<?php

namespace MyProject\HTTP\Controllers;

use Zer0\HTTP\Responses\Template;
use Zer0\HTTP\AbstractController;

final class Index extends AbstractController
{
    /**
     * @return Template
     */
    public function indexAction(): Template
    {
        return new Template('pages/Index/index.tpl');
    }
}
