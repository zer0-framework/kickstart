<?php

namespace MyProject\HTTP\Controllers;

use Zer0\HTTP\Exceptions\HttpError;
use Zer0\HTTP\Exceptions\MovedTemporarily;
use Zer0\HTTP\Responses\Base as BaseResponse;
use Zer0\HTTP\Responses\JSON;
use Zer0\HTTP\Responses\Template;
use Zer0\HTTP\AbstractController;

final class Error extends AbstractController
{
    /**
     * @var bool
     */
    protected $skipOriginCheck = true;

    /**
     * @param HttpError|null $error
     * @return null|BaseResponse
     */
    public function indexAction(HttpError $error = null): ?BaseResponse
    {
        // Compensating for /error/xxx
        $_SERVER['DOCUMENT_URI'] = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

        if ($error) {
            $code = $error->httpCode;
        } else {
            $code = (int)($_SERVER['ROUTE_ERRCODE'] ?? null);
        }

        if (!$this->http->isAjaxRequest()) {
            $this->http->responseCode($code);
        }
        if ($this->http->isAjaxRequest()) {
            return new JSON([
                '$exception' => $error ? [
                    'type' => get_class($error),
                    'message' => $error->getMessage(),
                    'previous' => (string)$error->getPrevious(),
                ] : null,
            ]);
        } else {
            return new Template('pages/Error/' . $code . '.tpl');
        }
    }
}
