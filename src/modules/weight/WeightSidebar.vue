<!--
	- @copyright Copyright (c) 2020 Florian Steffens <flost-dev@mailbox.org>
	-
	- @author Florian Steffens
	-
	- @license GNU AGPL version 3 or any later version
	-
	- This program is free software: you can redistribute it and/or modify
	- it under the terms of the GNU Affero General Public License as
	- published by the Free Software Foundation, either version 3 of the
	- License, or (at your option) any later version.
	-
	- This program is distributed in the hope that it will be useful,
	- but WITHOUT ANY WARRANTY; without even the implied warranty of
	- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	- GNU Affero General Public License for more details.
	-
	- You should have received a copy of the GNU Affero General Public License
	- along with this program. If not, see <http://www.gnu.org/licenses/>.
	-
	-->

<template>
	<ul>
		<li><h3>{{ t('health', 'Column selection', {}) }}</h3></li>
		<ActionCheckbox
			:checked="person.weightColumnWeight"
			@change="$store.dispatch('setValue', { key: 'weightColumnWeight', value: $event.target.checked })">
			{{ t('health', 'Weight', {}) }}
		</ActionCheckbox>
		<ActionCheckbox
			:checked="person.weightColumnBmi"
			@change="$store.dispatch('setValue', { key: 'weightColumnBmi', value: $event.target.checked })">
			{{ t('health', 'Body mass index (BMI)', {}) }}
		</ActionCheckbox>
		<ActionCheckbox
			:checked="person.weightColumnBodyfat"
			@change="$store.dispatch('setValue', { key: 'weightColumnBodyfat', value: $event.target.checked })">
			{{ t('health', 'Bodyfat', {}) }}
		</ActionCheckbox>
		<ActionCheckbox
			:checked="person.weightColumnMeasurement"
			@change="$store.dispatch('setValue', { key: 'weightColumnMeasurement', value: $event.target.checked })">
			{{ person.weightMeasurementName ? person.weightMeasurementName : t('health', 'Custom measurement') }}
		</ActionCheckbox>
		<ActionCheckbox
			:checked="person.weightColumnWaistSize"
			@change="$store.dispatch('setValue', { key: 'weightColumnWaistSize', value: $event.target.checked })">
			{{ t('health', 'Waist size', {}) }}
		</ActionCheckbox>
		<ActionCheckbox
			:checked="person.weightColumnHipSize"
			@change="$store.dispatch('setValue', { key: 'weightColumnHipSize', value: $event.target.checked })">
			{{ t('health', 'Hip size', {}) }}
		</ActionCheckbox>
		<ActionCheckbox
			:checked="person.weightColumnMusclePart"
			@change="$store.dispatch('setValue', { key: 'weightColumnMusclePart', value: $event.target.checked })">
			{{ t('health', 'Muscle part', {}) }}
		</ActionCheckbox>

		<li><h3>{{ t('health', 'General settings', {}) }}</h3></li>
		<li><h4>{{ t('health', 'Unit for weight', {}) }}</h4></li>
		<ActionInput
			type="text"
			:value="person.weightUnit"
			icon="icon-category-customization"
			@submit="updateWeightUnit" />
		<li>
			<h4>
				{{ t('health', 'Custom column name', {}) }}<span><br>{{ t('health', 'What else do you want to track? Set here a name and you can add data in the data-table. The values have to be numbers. Please do not forget to activate the column in the column selections.', {}) }}</span>
			</h4>
		</li>
		<ActionInput
			type="text"
			:value="person.weightMeasurementName"
			icon="icon-rename"
			@submit="updateMeasurementName" />
		<li>
			<h3 class="toggable"
				@click="showTargetOptions = !showTargetOptions">
				{{ t('health', 'Target', {}) }}
			</h3>
		</li>
		<li>
			<h4>
				{{ t('health', 'Weight target') }}
				<span>
					{{ t('health', 'in {unit}', { unit: person.weightUnit }) }}
					<br>
					{{ t('health', 'Leave blank for none.') }}
				</span>
			</h4>
		</li>
		<ActionInput
			type="number"
			:value="person.weightTarget"
			icon="icon-category-monitoring"
			@submit="updateWeightTarget" />
		<li>
			<h4>
				{{ t('health', 'Weight target initial weight') }}
				<span>
					{{ t('health', 'in {unit}', { unit: person.weightUnit }) }}
					<br>
					{{ t('health', 'This is your reference weight for the target.') }}
				</span>
			</h4>
		</li>
		<ActionInput
			type="number"
			:value="(person.weightTargetInitialWeight !== null )? person.weightTargetInitialWeight: ''"
			icon="icon-quota"
			@submit="updateWeightTargetInitialWeight" />
		<li>
			<h4>
				{{ t('health', 'Weight target bounty', {}) }}
			</h4>
		</li>
		<div class="textarea-sidebar">
			<textarea ref="weightTargetBounty" :value="person.weightTargetBounty" :placeholder="t('health', 'Add some bounty to motivate yourself, if you like to.', {})" />
		</div>
		<button
			@click="updateWeightTargetBounty">
			{{ t('health', 'Save bounty', {}) }}
		</button>
	</ul>
</template>

<script>
import ActionInput from '@nextcloud/vue/dist/Components/ActionInput'
import { mapState, mapGetters } from 'vuex'
import ActionCheckbox from '@nextcloud/vue/dist/Components/ActionCheckbox'

export default {
	name: 'WeightSidebar',
	components: {
		ActionInput,
		ActionCheckbox,
	},
	computed: {
		...mapState(['activeModule', 'showSidebar']),
		...mapGetters(['person']),
	},
	methods: {
		updateWeightUnit(e) {
			this.$store.dispatch('setValue', { key: 'weightUnit', value: e.target[1].value })
		},
		updateWeightTarget(e) {
			this.$store.dispatch('setValue', { key: 'weightTarget', value: e.target[1].value })
		},
		updateWeightTargetInitialWeight(e) {
			this.$store.dispatch('setValue', { key: 'weightTargetInitialWeight', value: e.target[1].value })
		},
		updateMeasurementName(e) {
			this.$store.dispatch('setValue', { key: 'weightMeasurementName', value: e.target[1].value })
		},
		updateWeightTargetBounty() {
			this.$store.dispatch('setValue', { key: 'weightTargetBounty', value: this.$refs.weightTargetBounty.value })
		},
	},
}
</script>
