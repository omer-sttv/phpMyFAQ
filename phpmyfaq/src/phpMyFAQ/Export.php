<?php

namespace phpMyFAQ;

/**
 * JSON, XML, HTML5 and PDF export
 *
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/.
 *
 * @package phpMyFAQ
 * @author Thorsten Rinne <thorsten@phpmyfaq.de>
 * @author Matteo Scaramuccia <matteo@scaramuccia.com>
 * @license http://www.mozilla.org/MPL/2.0/ Mozilla Public License Version 2.0
 * @copyright 2005-2019 phpMyFAQ Team
 * @link https://www.phpmyfaq.de
 * @since 2005-11-02
 */

use phpMyFAQ\Export\Html5;
use phpMyFAQ\Export\Json;
use phpMyFAQ\Export\Pdf;
use phpMyFAQ\Export\Xml;

if (!defined('IS_VALID_PHPMYFAQ')) {
    exit();
}

require_once PMF_CONFIG_DIR.'/constants.php';

/**
 * Class Export
 * @package phpMyFAQ
 */
class Export
{
    /**
     * FaqHelper object.
     *
     * @var Faq
     */
    protected $faq = null;

    /**
     * CategoryHelper object.
     *
     * @var Category
     */
    protected $category = null;

    /**
     * Configuration.
     *
     * @var Configuration
     */
    protected $_config = null;

    /**
     * Factory.
     *
     * @param Faq $faq FaqHelper object
     * @param Category $category Entity object
     * @param Configuration $config Configuration object
     * @param string $mode Export
     * @return mixed
     * @throws Exception
     * @throws \Exception
     */
    public static function create(Faq $faq, Category $category, Configuration $config, $mode = 'pdf')
    {
        switch ($mode) {
            case 'json':
                return new Json($faq, $category, $config);
                break;
            case 'pdf':
                return new Pdf($faq, $category, $config);
                break;
            case 'xml':
                return new Xml($faq, $category, $config);
                break;
            case 'html5':
                return new Html5($faq, $category, $config);
                break;
            default:
                throw new Exception('Export not implemented!');
        }
    }
}
