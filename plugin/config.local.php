<?php
// This file is part of Moodle - http://moodle.org/
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
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

// Additional config for excluding the Arlo tables so that merge contacts can process.
// Add the original tables from the config.php file, and then add the arlo tables that
// we need to ignore.
return [
    'exceptions' => [
        'user_preferences',
        'user_private_key',
        'user_info_data',
        'my_pages',
        'enrol_arlo_registration',
        'enrol_arlo_contact',
        'enrol_arlo_emailqueue',
    ]
];

$CFG->site_is_public = false;