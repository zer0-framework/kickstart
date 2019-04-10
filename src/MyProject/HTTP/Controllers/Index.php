<?php

namespace MyProject\HTTP\Controllers;

use Zer0\HTTP\Responses\Template;

final class Index extends Base
{
    /**
     * @return Template
     */
    public function indexAction(): Template
    {
        return new Template('pages/Index/index.tpl');
    }
}
