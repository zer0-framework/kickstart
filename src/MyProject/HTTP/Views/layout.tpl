{?$layoutName = 'main'}
{?$bundles = ['main']}

{if !$isPjax}<!DOCTYPE html>
<!doctype html>
<html class="no-js" lang="">
{/if}

<head prefix="og: http://ogp.me/ns#">
    <title>{block title}{/block}</title>
    <meta name="csrf-token" content="{$csrfToken}">
</head>
<body>
    <div id="pjax-container">


{block content}{/block}

{if $tracy}{?$tracy->renderBar()}{/if}
</div>
{if !$isPjax}
<!-- footer -->
{/if}
<!-- Generated in {round(microtime(true) - $quicky.server.REQUEST_TIME_FLOAT, 5)} sec. -->
</body>
{if !$isPjax}
</html>
{/if}
