<?php
// This file is part of Moodle - https://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <https://www.gnu.org/licenses/>.

namespace filter_mermaid;

/**
 * Main filter class of the plugin
 *
 * Moved from filter/mermaid/filter.php per MDL-82427: legacy filter.php
 * class naming is deprecated in favour of classes/text_filter.php.
 *
 * @package   filter_mermaid
 * @copyright 2025 Lukas OTERO--MELEDO
 * @license https://www.gnu.org/licenses/gpl-3.0.en.html
 */
class text_filter extends \moodle_text_filter {

    /**
     * Get the formated text with Mermaid diagrams
     * @param string $text
     * @param array $options
     * @return string
     */
    public function filter($text, array $options = []) {
        global $CFG;

        if (!is_string($text) || empty($text)) {
            return $text;
        }

        $re = "~\[mermaid(.*?)\](.*?)\[\/mermaid\]~isu";
        $result = preg_match_all($re, $text, $matches);
        if ($result > 0) {
            foreach ($matches[2] as $idx => $code) {
                $code = strip_tags(str_replace('<br>', PHP_EOL, $code));
                $text = str_replace($matches[0][$idx], '<pre class="mermaid">'.$code.'</pre>', $text);
            }

            $text .= "<script type=\"module\">
                import mermaid from '".$CFG->wwwroot."/filter/mermaid/javascript/mermaid.esm.min.mjs';
                mermaid.initialize({ startOnLoad: true });
              </script>";
        }
        return $text;
    }
}
