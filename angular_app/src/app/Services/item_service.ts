import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { CatalogItem } from '../Models/catalog-item.model';
import { environment } from '../../Enviroments/enviroments';

@Injectable({
    providedIn: 'root'
})
export class ItemService {
    private baseUrl = environment.apiBaseUrl;

    constructor(private http: HttpClient) { }

    getItems(): Observable<CatalogItem[]> {
        return this.http.get<CatalogItem[]>(this.baseUrl);
    }

    getItem(id: string): Observable<CatalogItem> {
        return this.http.get<CatalogItem>(`${this.baseUrl}/${id}`);
    }

    createItem(item: Partial<CatalogItem>): Observable<CatalogItem> {
        return this.http.post<CatalogItem>(this.baseUrl, item);
    }

    approveItem(id: string): Observable<CatalogItem> {
        return this.http.patch<CatalogItem>(`${this.baseUrl}/${id}/approve`, {});
    }
}