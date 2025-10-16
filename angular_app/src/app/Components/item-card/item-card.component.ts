import { Component, Input, signal, WritableSignal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CatalogItem } from '../../Models/catalog-item.model';
import { ItemService } from '../../Services/item_service';

@Component({
    selector: 'app-item-card',
    standalone: true,
    imports: [CommonModule],
    template: `
    <div class="card" style="border: 1px solid #ccc; padding: 16px; margin-bottom: 12px; border-radius: 8px;">
      <h3>{{ item.title }}</h3>
      <p><strong>Description:</strong> {{ item.description }}</p>
      <p><strong>Category:</strong> {{ item.category || 'N/A' }}</p>
      <p><strong>Tags:</strong> {{ item.tags.join(', ') || 'None' }}</p>
      <p><strong>Quality Score:</strong> {{ item.qualityScore }}</p>

      <div style="margin-top: 12px;">
        @if(item.approved){
            <span style="color: gray;">
                Item already approved ✅
            </span>
        } @else if(item.qualityScore >= 90 && !item.approved){
            <button (click)="approveItem()" style="padding: 6px 12px; cursor: pointer;">
                Approve
            </button>
        } @else {
            <span style="color: gray;">
                Cannot approve: quality score must be ≥ 90
            </span>
        }
      </div>
    </div>
  `
})
export class ItemCardComponent {
    @Input() item!: CatalogItem;
    @Input() itemList!: WritableSignal<CatalogItem[]>;

    constructor(private itemService: ItemService) { }

    approveItem() {
        if (this.item.qualityScore >= 90 && !this.item.approved) {
            console.log(this.item.id);
            this.itemService.approveItem(this.item.id).subscribe(updated => {
                this.itemList.update(list =>
                    list.map(i => (i.id === updated.id ? updated : i))
                );
                this.item = updated;
            });
        }
    }
}
