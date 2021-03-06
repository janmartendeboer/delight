<?php

declare(strict_types=1);

use Delight\Website\ContextCompilerInterface;
use Twig\Environment;

function render(string $page, array $data = []): string
{
    /** @var Environment $environment */
    static $environment;

    if (!$environment instanceof Environment) {
        $environment = require_once __DIR__ . '/environment.php';
    }

    return $environment->render(
        in_array(pathinfo($page, PATHINFO_EXTENSION), ['json', 'xml'])
            ? sprintf('pages/%s.twig', $page)
            : sprintf('pages/%s.html.twig', $page),
        compileContext(
            array_replace_recursive(
                $data,
                ['_route' => $page]
            )
        )
    );
}

function compileContext(array $context): array
{
    /** @var ContextCompilerInterface $compiler */
    static $compiler;

    if (!isset($compiler)) {
        $compiler = require_once __DIR__ . '/context.php';
    }

    return $compiler->compile(
        $context
    );
}
