import { Component, signal, computed, Signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ItemService } from '../../Services/item_service';
import { CatalogItem } from '../../Models/catalog-item.model';
import { ItemCardComponent } from '../item-card/item-card.component';

@Component({
    selector: 'app-item-list',
    standalone: true,
    imports: [CommonModule, ItemCardComponent],
    template: `
    
    <div>
      <input [value]="search()" (input)="search.set($any($event.target).value)" placeholder="Search..." />
      <select [value]="categoryFilter()" (change)="categoryFilter.set($any($event.target).value)">
        <option value="">All Categories</option>
        @for (cat of categories(); track cat){
          <option [value]="cat">{{ cat }}</option>
        }
      </select>
      <select [value]="sortOrder()" (change)="sortOrder.set($any($event.target).value)">
        <option value="desc">Quality Score Descending</option>
        <option value="asc">Quality Score Ascending</option>
      </select>
      <button (click)="refresh()">Refresh</button>
    </div>

    @for (item of filteredAndSortedItems(); track item.id){
        <div (click)="selectedItem.set(item)">
            <strong>{{ item.title }}</strong> - {{ item.qualityScore }} pts
            @if(item.approved){
                <span>✅ Approved</span>
            }
        </div>
    }

    @if (selectedItem()){
        <h2>Item Details</h2>
        <app-item-card [item]="selectedItem()!" [itemList]="items"></app-item-card>
    }
  
  `
})
export class ItemListComponent {

    items = signal<CatalogItem[]>([]);
    search = signal('');
    categoryFilter = signal('');
    sortOrder = signal<'asc' | 'desc'>('desc');
    selectedItem = signal<CatalogItem | null>(null);

    categories = computed(() => {
        const cats = new Set(this.items().map(i => i.category).filter(c => c));
        return Array.from(cats);
    });

    filteredAndSortedItems = computed(() => {
        let filtered = this.items().filter(item => {
            const matchesSearch = item.title.toLowerCase().includes(this.search().toLowerCase());
            const matchesCategory = this.categoryFilter() ? item.category === this.categoryFilter() : true;
            return matchesSearch && matchesCategory;
        });

        return filtered.sort((a, b) =>
            this.sortOrder() === 'asc'
                ? a.qualityScore - b.qualityScore
                : b.qualityScore - a.qualityScore
        );
    });

    constructor(private itemService: ItemService) {
        this.loadItems();
    }


    loadItems() {
        this.itemService.getItems().subscribe(data => this.items.set(data));
    }

    refresh() {
        this.loadItems();
    }
}