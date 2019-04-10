{?$layoutName = 'main'}
{?$bundles = ['main']}

{if !$isPjax}<!DOCTYPE html>
<!doctype html>
<html class="no-js" lang="">
{/if}

<head prefix="og: http://ogp.me/ns#">
    <title>{block title}{/block}</title>
    <meta name="csrf-token" content="{$csrfToken}">
    <!-- Bootstrap core CSS -->
    <link href="/dist/node_modules/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">

     {if $env === 'prod'}
        {foreach from=$bundles item=$bundle}
            <link rel="stylesheet" type="text/css" href="/dist/{$bundle}.bundle.min.css?{$buildTimestamp}">
        {/foreach}
    {else}
        {foreach from=$bundles item=$bundle}
            <link rel="stylesheet" type="text/css" href="/dist/{$bundle}.bundle.css?{time()}">
        {/foreach}
    {/if}
</head>

  <body>
<div id="pjax-container">
    <header>
      <!-- Fixed navbar -->
      <nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
        <a class="navbar-brand" href="#">Fixed navbar</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarCollapse">
          <ul class="navbar-nav mr-auto">
            <li class="nav-item active">
              <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#">Link</a>
            </li>
            <li class="nav-item">
              <a class="nav-link disabled" href="#">Disabled</a>
            </li>
          </ul>
          <form class="form-inline mt-2 mt-md-0">
            <input class="form-control mr-sm-2" type="text" placeholder="Search" aria-label="Search">
            <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
          </form>
        </div>
      </nav>
    </header>
{block content}{/block}
    <!-- Begin page content -->
    <main role="main" class="container">
      <h1 class="mt-5">Sticky footer with fixed navbar</h1>
      <p class="lead">Pin a fixed-height footer to the bottom of the viewport in desktop browsers with this custom HTML and CSS. A fixed navbar has been added with <code>padding-top: 60px;</code> on the <code>body &gt; .container</code>.</p>
      <p>Back to <a href="../sticky-footer">the default sticky footer</a> minus the navbar.</p>
    </main>

    <footer class="footer">
      <div class="container">
        <span class="text-muted">Place sticky footer content here.</span>
      </div>
    </footer>

{if $tracy}{?$tracy->renderBar()}{/if}
</div>
{if !$isPjax}
<!-- footer -->
{/if}
<!-- Generated in {round(microtime(true) - $quicky.server.REQUEST_TIME_FLOAT, 5)} sec. -->
</body>
{if !$isPjax}

{if $env === 'prod'}
{foreach from=$bundles item=$bundle}
    <script type="text/javascript" src="/dist/{$bundle}.bundle.min.js?{$buildTimestamp}"></script>
{/foreach}
{else}
{foreach from=$bundles item=$bundle}
    <script type="text/javascript" src="/dist/{$bundle}.bundle.js?{time()}"></script>
{/foreach}
{/if}

    </html>
{/if}
