export interface CatalogItem {

    id: string;
    title: string;
    description: string;
    category?: string;
    tags: string[];
    approved: boolean;
    qualityScore: number;

}