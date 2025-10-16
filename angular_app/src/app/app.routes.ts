import { Routes } from '@angular/router';
import { ItemListComponent } from './Components/item-list/item-list.component';

export const routes: Routes = [
    {
        path: '',
        redirectTo: 'admin',
        pathMatch: 'full',
    },
    {
        path: 'admin',
        component: ItemListComponent
    }
];
