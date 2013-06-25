package {

	import flash.display.Sprite;
	import flash.text.TextField;

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.selectors.selectors.SelectorPool;

	public class MatchingSpeedTest extends BasicProfilingSprite {


		private var _selectorPool:SelectorPool


				
		private var _infoButton:Sprite;
		private var _icon:Sprite;
		private var _scoutButton:Sprite;
		private var _textField:TextField;


		override protected function prepare():void {
			_selectorPool = _selectorFactory.createSelectorPool();

			_selectorPool.addSelector("Label");
			_selectorPool.addSelector("HeadsUpDisplay");
			_selectorPool.addSelector("#leftResourceContainer");
			_selectorPool.addSelector("#centerResourceContainer");
			_selectorPool.addSelector("#rightResourceContainer");
			_selectorPool.addSelector("ResourceView");
			_selectorPool.addSelector("ResourceView > #label");
			_selectorPool.addSelector("ResourceView > Label > TextField");
			_selectorPool.addSelector("#populationResource > #label");
			_selectorPool.addSelector("#energyResource > #label");
			_selectorPool.addSelector("#goldResource");
			_selectorPool.addSelector("#woodResource");
			_selectorPool.addSelector("#stoneResource");
			_selectorPool.addSelector("#foodResource");
			_selectorPool.addSelector("#populationResource");
			_selectorPool.addSelector("#energyResource");
			_selectorPool.addSelector("#xpResource");
			_selectorPool.addSelector("Sprite#missionIconContainer");
			_selectorPool.addSelector("Sprite#missionIconContainer > MissionIconView");
			_selectorPool.addSelector("Sprite#missionIconContainer > MissionIconView:hover");
			_selectorPool.addSelector("FriendBarView");
			_selectorPool.addSelector("FriendBarView > Sprite#cityName");
			_selectorPool.addSelector("FriendBarView > Sprite#friends");
			_selectorPool.addSelector("FriendBarView > Sprite#friends > #friendContainer");
			_selectorPool.addSelector("FriendBarView > Sprite#friends > #friendContainer > FriendView");
			_selectorPool.addSelector("VisitFriendButton");
			_selectorPool.addSelector("#buttonContainer");
			_selectorPool.addSelector("#buttonContainer > :is-a(Button)");
			_selectorPool.addSelector("#buttonContainer > ShowBattleResultPopupButton");
			_selectorPool.addSelector("#buttonContainer > :is-a(Button):hover");
			_selectorPool.addSelector("#buttonContainer > :is-a(Button):checked");
			_selectorPool.addSelector("ScrollPane");
			_selectorPool.addSelector("ScrollPane > Button");
			_selectorPool.addSelector(":is-a(ScrollPane) > Button#BtnSkipLeft");
			_selectorPool.addSelector(":is-a(ScrollPane) > Button#BtnSkipRight");
			_selectorPool.addSelector("#popupCloseButton");
			_selectorPool.addSelector("#popupBackground");
			_selectorPool.addSelector("#popupHeadlineLabel");
			_selectorPool.addSelector("#popupHeadlineLabel > TextField");
			_selectorPool.addSelector("NotEnoughStoragePopup > PopupCloseButton, NotEnoughRequirementsPopup > PopupCloseButton, NotEnoughResourcesPopup > PopupCloseButton, ConfirmationPopup > PopupCloseButton, LevelUpPopup > PopupCloseButton, AlertPopup > PopupCloseButton, ShowRemaindersPopup > PopupCloseButton");
			_selectorPool.addSelector("NotEnoughStoragePopup > Label, NotEnoughRequirementsPopup > Label, NotEnoughResourcesPopup > Label, ConfirmationPopup > Label, LevelUpPopup > Label, AlertPopup > Label");
			_selectorPool.addSelector("ShopPopup");
			_selectorPool.addSelector("ShopPopup > PopupCloseButton");
			_selectorPool.addSelector("ShopPopup > Button");
			_selectorPool.addSelector("ShopPopup > #navigationBar");
			_selectorPool.addSelector("ShopPopup > #navigationBar > LabelButton");
			_selectorPool.addSelector("ShopPopup > #navigationBar > LabelButton:hover");
			_selectorPool.addSelector("ShopPopup > #navigationBar > LabelButton > Label");
			_selectorPool.addSelector("ShopPopup > #navigationBar > LabelButton > Label > TextField");
			_selectorPool.addSelector("ShopPopup > #navigationBar > LabelButton:checked > Label > TextField");
			_selectorPool.addSelector("ShopPopup TabContent");
			_selectorPool.addSelector("PageContent");
			_selectorPool.addSelector("PageContent > #pageLabel");
			_selectorPool.addSelector("PageContent > Label#pageLabel > TextField");
			_selectorPool.addSelector("PageContent #scrollContainer");
			_selectorPool.addSelector("#pagesContainer #page");
			_selectorPool.addSelector("ShopItemView");
			_selectorPool.addSelector("ShopItemView > #buyButton > Label");
			_selectorPool.addSelector("ShopItemView > #buyButton > Label > TextField");
			_selectorPool.addSelector("ShopItemView > Label#itemName");
			_selectorPool.addSelector("ShopItemView > Label#itemName > TextField");
			_selectorPool.addSelector("ShopItemView > #requiresValueLabel");
			_selectorPool.addSelector("ShopItemView > #requiresValueLabel > TextField");
			_selectorPool.addSelector("ShopItemView > #requiresLabel");
			_selectorPool.addSelector("ShopItemView > #requiresLabel > TextField");
			_selectorPool.addSelector("PageContent > Button");
			_selectorPool.addSelector("PageContent > Button#BtnSkipLeft");
			_selectorPool.addSelector("PageContent > Button#BtnSkipRight");
			_selectorPool.addSelector("InventoryPopup");
			_selectorPool.addSelector("InventoryPopup > PopupCloseButton");
			_selectorPool.addSelector("InventoryPopup > Button");
			_selectorPool.addSelector("InventoryPopup > PopupCloseButton");
			_selectorPool.addSelector("InventoryPopup > ScrollPane");
			_selectorPool.addSelector("InventoryItemView");
			_selectorPool.addSelector("InventoryItemView > #icon");
			_selectorPool.addSelector("SelectContractPopup");
			_selectorPool.addSelector("SelectContractPopup > PopupCloseButton");
			_selectorPool.addSelector("SelectContractPopup > #contractContainer");
			_selectorPool.addSelector("SelectContractPopup > #contractContainer > ContractView");
			_selectorPool.addSelector("SelectContractPopup > #contractContainer > ContractView > *");
			_selectorPool.addSelector("SelectContractPopup > #contractContainer > ContractView > Label");
			_selectorPool.addSelector("NotEnoughStoragePopup, NotEnoughRequirementsPopup, NotEnoughResourcesPopup, ConfirmationPopup, LevelUpPopup, AlertPopup");
			_selectorPool.addSelector("ConfirmationPopup > LabelButton");
			_selectorPool.addSelector("ConfirmationPopup > #ok");
			_selectorPool.addSelector("ConfirmationPopup > #cancel");
			_selectorPool.addSelector("ConfirmationPopup > LabelButton > Label");
			_selectorPool.addSelector("LevelUpPopup > LabelButton");
			_selectorPool.addSelector("LevelUpPopup > #ok");
			_selectorPool.addSelector("LevelUpPopup > LabelButton > Label");
			_selectorPool.addSelector("LevelButtonView");
			_selectorPool.addSelector("LevelButtonView > Label");
			_selectorPool.addSelector("ShowRemaindersPopup");
			_selectorPool.addSelector("ShowRemaindersPopup > LabelButton#ok");
			_selectorPool.addSelector("ShowRemaindersPopup > LabelButton > Label");
			_selectorPool.addSelector("TrainingPopup, AcademyPopup");
			_selectorPool.addSelector("TrainingPopup PopupCloseButton, AcademyPopup PopupCloseButton");
			_selectorPool.addSelector("ContractItemView");
			_selectorPool.addSelector("ContractItemView > Label");
			_selectorPool.addSelector("ContractItemView > #unlockButton > Label");
			_selectorPool.addSelector("TrainingRunningContractItemView > Button, AcademyRunningContractItemView > Button");
			_selectorPool.addSelector("ContractItemView > Button");
			_selectorPool.addSelector("TrainingRunningContractItemView, AcademyRunningContractItemView");
			_selectorPool.addSelector("#contractDetailsView");
			_selectorPool.addSelector("#contractDetailsTypeLabel");
			_selectorPool.addSelector("#contractDetailsLevelLabel");
			_selectorPool.addSelector("#contractDetailsDurationLabel");
			_selectorPool.addSelector("#contractDetailsView > LabelButton");
			_selectorPool.addSelector("ContractsQueueView");
			_selectorPool.addSelector("EnemySelectionPopup");
			_selectorPool.addSelector("EnemySelectionPopup > #nameLabel");
			_selectorPool.addSelector("EnemySelectionPopup PopupCloseButton");
			_selectorPool.addSelector("EnemySelectionPopup > #navigationBar");
			_selectorPool.addSelector("EnemySelectionPopup > #navigationBar Label");
			_selectorPool.addSelector("EnemySelectionPopup > #navigationBar > #search");
			_selectorPool.addSelector("EnemySelectionPopup > #navigationBar > NavigationButton > Label > TextField");
			_selectorPool.addSelector("EnemySelectionPopup TabContent");
			_selectorPool.addSelector("DataPage DataGridHeader");
			_selectorPool.addSelector("DataPage DataGridHeaderButton");
			_selectorPool.addSelector("DataPage PageableDataGrid");
			_selectorPool.addSelector("DataPage PageableDataGrid > #scrollContainer");
			_selectorPool.addSelector("DataPage PageableDataGrid > #scrollContainer DataGrid");
			_selectorPool.addSelector("DataPage #dataPages > #pageLabel");
			_selectorPool.addSelector("DataPage #dataPages > Label#pageLabel > TextField");
			_selectorPool.addSelector("DataPage #dataPages #pagesContainer");
			_selectorPool.addSelector("DataPage #dataPages > Button#BtnSkipLeft");
			_selectorPool.addSelector("DataPage #dataPages > Button#BtnSkipRight");
			_selectorPool.addSelector("DataPage #dataPages #pagesContainer");
			_selectorPool.addSelector("DataPage #dataPages > Button");
			_selectorPool.addSelector("#dataGridRow > Label");
			_selectorPool.addSelector("#dataGridRow > Label > TextField");
			_selectorPool.addSelector("#dataGridRow #colLevel");
			_selectorPool.addSelector("#dataGridRow #colLevel > TextField");
			_selectorPool.addSelector("#dataGridRow #colStatus");
			_selectorPool.addSelector("#dataGridRow #colStatus > TextField");
			_selectorPool.addSelector("#dataGridRow > #colInteraction");
			_selectorPool.addSelector("#dataGridRow > #colInteraction > #scoutBtn");
			_selectorPool.addSelector("#dataGridRow > #colInteraction > #messageBtn");
			_selectorPool.addSelector("#dataGridRow > #colInteraction > #scoutBtn TextField");
			_selectorPool.addSelector("#dataGridRow > #colInteraction > #messageBtn TextField");
			_selectorPool.addSelector("EnemySelectionPopup > #searchInput");
			_selectorPool.addSelector("BattleResultPopup");
			_selectorPool.addSelector("BattleResultPopup > #suggestionText, BattleResultPopup > #battleTips");
			_selectorPool.addSelector("BattleResultPopup > #attackerDisplay, BattleResultPopup > #defenderDisplay");
			_selectorPool.addSelector("BattleResultPopup > #attackerDisplay");
			_selectorPool.addSelector("BattleResultPopup > #defenderDisplay");
			_selectorPool.addSelector("PlayerDisplay > #playerImage");
			_selectorPool.addSelector("PlayerDisplay > #shield");
			_selectorPool.addSelector("PlayerDisplay > #shield > Label");
			_selectorPool.addSelector("PlayerDisplay > #playerName");
			_selectorPool.addSelector("BattleResultPopup > #troopDisplay");
			_selectorPool.addSelector("BattleResultPopup > #suggestionText");
			_selectorPool.addSelector("BattleResultPopup > #battleTips");
			_selectorPool.addSelector("BattleResultPopup > #troopsLost, BattleResultPopup > #buildingsDestroyed");
			_selectorPool.addSelector("BattleResultPopup > #troopsLost");
			_selectorPool.addSelector("BattleResultPopup > #buildingsDestroyed");
			_selectorPool.addSelector("BattleResultPopup > AmountWithInfoBox");
			_selectorPool.addSelector("BattleResultPopup > AmountWithInfoBox > #headline");
			_selectorPool.addSelector("BattleResultPopup > AmountWithInfoBox > #amount");
			_selectorPool.addSelector("BattleResultPopup > AmountWithInfoBox > #infoButton");
			_selectorPool.addSelector("BattleResultPopup > AmountWithInfoBox > #infoButton > #infoBox");
			_selectorPool.addSelector("BattleResultPopup > AmountWithInfoBox > #infoButton:hover > #infoBox");
			_selectorPool.addSelector("AmountWithInfoBox > #infoButton:hover > #infoBox > #row");
			_selectorPool.addSelector("AmountWithInfoBox > #infoButton:hover > #infoBox > #row > #key");
			_selectorPool.addSelector("#infoButton");
			_selectorPool.addSelector("#infoButton:hover");
			_selectorPool.addSelector("BattleResultPopup > #resourcesLooted");
			_selectorPool.addSelector("BattleResultPopup > #resourcesLooted > #headline");
			_selectorPool.addSelector("BattleResultPopup > #resourcesLooted > LootedResourceView");
			_selectorPool.addSelector("BattleResultPopup > #resourcesLooted > LootedResourceView > #amount");
			_selectorPool.addSelector("BattleResultPopup > #resourcesLooted > LootedResourceView > #icon");
			_selectorPool.addSelector("BattleResultPopup > #resourcesLooted > LootedResourceView#wood > #icon");
			_selectorPool.addSelector("BattleResultPopup > #resourcesLooted > LootedResourceView#gold > #icon");
			_selectorPool.addSelector("BattleResultPopup > #resourcesLooted > LootedResourceView#food > #icon");
			_selectorPool.addSelector("BattleResultPopup > #resourcesLooted > LootedResourceView#stone > #icon");
			_selectorPool.addSelector("BattleResultPopup > #gainedExperience, BattleResultPopup > #gainedInfamy");
			_selectorPool.addSelector("BattleResultPopup > NumberWithIcon > #infoButton > #infoBox");
			_selectorPool.addSelector("BattleResultPopup > NumberWithIcon > #infoButton:hover > #infoBox");
			_selectorPool.addSelector("BattleResultPopup > NumberWithIcon > #icon");
			_selectorPool.addSelector("BattleResultPopup > NumberWithIcon > #amount");
			_selectorPool.addSelector("BattleResultPopup > #gainedExperience > #infoButton");
			_selectorPool.addSelector("BattleResultPopup > NumberWithIcon > #infoButton");
			_selectorPool.addSelector("BattleResultPopup > #gainedExperience");
			_selectorPool.addSelector("BattleResultPopup > #gainedInfamy");
			_selectorPool.addSelector("BattleResultPopup > #itemsLooted");
			_selectorPool.addSelector("BattleResultPopup > #itemsLooted > #headline");
			_selectorPool.addSelector("BattleResultPopup > #itemsLooted > LootedItemView");
			_selectorPool.addSelector("BattleResultPopup > #itemsLooted > LootedItemView > #amount");
			_selectorPool.addSelector("BattleResultPopup > #itemsLooted > LootedItemView > #icon");
			_selectorPool.addSelector("BattleResultPopup > #itemsLooted > LootedItemView > #icon > :is-a(Sprite)");
			_selectorPool.addSelector("BattleResultPopup > #buttonsContainer");
			_selectorPool.addSelector("BattleResultPopup > #buttonsContainer > LabelButton");
			_selectorPool.addSelector("BattleResultPopup > #buttonsContainer > LabelButton:hover");
			_selectorPool.addSelector("#combatContainer");
			_selectorPool.addSelector("#combatContainer > #buttonContainer");
			_selectorPool.addSelector(":is-a(UnitsView)");
			_selectorPool.addSelector(":is-a(UnitsView) > Button#BtnSkipLeft");
			_selectorPool.addSelector(":is-a(UnitsView) > Button#BtnSkipRight");
			_selectorPool.addSelector(":is-a(UnitAmountView)");
			_selectorPool.addSelector(":is-a(UnitAmountView) > #all");
			_selectorPool.addSelector(":is-a(UnitAmountView)[selectedAmount='0'] > #minus");
			_selectorPool.addSelector(":is-a(UnitAmountView) > #minus");
			_selectorPool.addSelector(":is-a(UnitAmountView) > #count");
			_selectorPool.addSelector(":is-a(UnitAmountView) > #icon");
			_selectorPool.addSelector("#metaInfoView");
			_selectorPool.addSelector("#MetaNameLabel");
			_selectorPool.addSelector("#MetaLevelLabel");
			_selectorPool.addSelector("#MetaUpgradeButton");


			var displayTree:DisplayTree = new DisplayTree();
			var instances:Array = [];

			displayTree.uses(this).containing
				.a(Sprite).withTheName("infoButton") .whichWillBeStoredIn(instances)
				.a(Sprite).withTheName("icon") .whichWillBeStoredIn(instances)
				.a(Sprite).withTheName("dataGridRow").containing
					.a(Sprite).withTheName("colInteraction").containing
						.a(Sprite).withTheName("scoutBtn") .whichWillBeStoredIn(instances) .containing
							.a(Sprite) .containing
								.a(Sprite) .containing
									.a(TextField) .whichWillBeStoredIn(instances)
								.end
							.end
						.end
					.end
				.end
			.end.finish();

			_infoButton = instances[0] as Sprite;
			_icon = instances[1] as Sprite;
			_scoutButton = instances[2] as Sprite;
			_textField = instances[3] as TextField;

		}

		override protected function performAction():void {


			for(var i:int = 0; i < 1000; ++i) {

				_selectorPool.getSelectorsMatchingObject(_infoButton);
				_selectorPool.getSelectorsMatchingObject(_icon);
				_selectorPool.getSelectorsMatchingObject(_scoutButton);
				_selectorPool.getSelectorsMatchingObject(_textField);
			}


		}
	}
}
