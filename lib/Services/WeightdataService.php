<?php
declare(strict_types=1);
/**
 * @copyright Copyright (c) 2020 Florian Steffens <flost-dev@mailbox.org>
 *
 * @author Florian Steffens <flost-dev@mailbox.org>
 *
 * @license GNU AGPL version 3 or any later version
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

namespace OCA\Health\Services;

use Exception;
use OCA\Health\Db\Weightdata;
use OCA\Health\Db\WeightdataMapper;
use OCA\Health\Services\FormatHelperService;
use OCP\AppFramework\Http;

class WeightdataService {

	protected $weightdataMapper;
	protected $userId;
	protected $formatHelperService;
	protected $permissionService;

	public function __construct($userId, WeightdataMapper $wdM, FormatHelperService $fhS, PermissionService $permissionService) {
		$this->userId = $userId;
		$this->weightdataMapper = $wdM;
		$this->formatHelperService = $fhS;
		$this->permissionService = $permissionService;
	}

	public function getAllByPersonId($personId) {
		if( !$this->permissionService->personData($personId, $this->userId)) {
			return null;
		}
		return $this->weightdataMapper->findAll($personId);
	}

	public function getLastWeight($personId) {
		if( !$this->permissionService->personData($personId, $this->userId)) {
			return null;
		}
		return $this->weightdataMapper->findLast($personId);
	}

	public function create($personId, $weight, $waist, $hip, $measurement, $bodyfat, $date) {
		if( !$this->permissionService->weightData($personId, $this->userId)) {
			return null;
		}
		$time = new \DateTime();
		try {
			$date = new \DateTime($date);
		} catch (Exception $e) {
			$date = new \DateTime();
		}
		$wd = new Weightdata();
		$wd->setDate($date->format('Y-m-d H:i:s'));
		/** @noinspection PhpUndefinedMethodInspection */
		$wd->setInsertTime($time->format('Y-m-d H:i:s'));
		/** @noinspection PhpUndefinedMethodInspection */
		$wd->setLastupdateTime($time->format('Y-m-d H:i:s'));
		/** @noinspection PhpUndefinedMethodInspection */
		$wd->setPersonId($personId);
		/** @noinspection PhpUndefinedMethodInspection */
		$wd->setWeight($weight);
		/** @noinspection PhpUndefinedMethodInspection */
		$wd->setWaist($waist);
		/** @noinspection PhpUndefinedMethodInspection */
		$wd->setHip($hip);
		/** @noinspection PhpUndefinedMethodInspection */
		$wd->setMeasurement($measurement);
		/** @noinspection PhpUndefinedMethodInspection */
		$wd->setBodyfat($bodyfat);
		// error_log(print_r($wd, true));
		return $this->weightdataMapper->insert($wd);
	}

	public function delete($id) {
		if( !$this->permissionService->weightData($id, $this->userId)) {
			return null;
		}
		try {
			$wd = $this->weightdataMapper->find($id);
        } catch(Exception $e) {
             return Http::STATUS_NOT_FOUND;
		}
		return $this->weightdataMapper->delete($wd);
	}

	public function update($id, $date, $weight, $waist, $hip, $measurement, $bodyfat) {
		if( !$this->permissionService->weightData($id, $this->userId)) {
			return null;
		}
		try {
			$wd = $this->weightdataMapper->find($id);
			$wd->setDate($this->formatHelperService->typeCast('date', $date));
			/** @noinspection PhpUndefinedMethodInspection */
			$wd->setWeight($this->formatHelperService->typeCast('weight', $weight));
			/** @noinspection PhpUndefinedMethodInspection */
			$wd->setWaist($this->formatHelperService->typeCast('waist', $waist));
			/** @noinspection PhpUndefinedMethodInspection */
			$wd->setHip($this->formatHelperService->typeCast('hip', $hip));
			/** @noinspection PhpUndefinedMethodInspection */
			$wd->setMeasurement($this->formatHelperService->typeCast('measurement', $measurement));
			/** @noinspection PhpUndefinedMethodInspection */
			$wd->setBodyfat($this->formatHelperService->typeCast('bodyfat', $bodyfat));
        } catch(Exception $e) {
             return Http::STATUS_NOT_FOUND;
		}
		return $this->weightdataMapper->update($wd);
	}
}
