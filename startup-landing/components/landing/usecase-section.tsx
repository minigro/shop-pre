"use client";

import { cn } from "@/lib/utils";
import { CheckIcon } from "@radix-ui/react-icons";
import Image from "next/image";
import { useState } from "react";

type Interval = "month" | "year";

export const toHumanPrice = (price: number, decimals: number = 2) => {
    return Number(price / 100).toFixed(decimals);
};
const caseCards = [
    {
        id: "price_1",
        name: "Microgreens",
        description: "Cultivate a variety of nutrient-dense microgreens, perfect for adding flavor and color to any dish.",
        image: "/microgreens.jpg",
        features: [
            "Helthy snaks",
            "Salads",
            "Whatever you want",
            "Sustainable future",
        ],
        monthlyPrice: 1000,
        yearlyPrice: 10000,
        isMostPopular: false,
    },
    {
        id: "price_2",
        name: "Herbs",
        description: "Grow fresh, aromatic herbs to enhance your culinary creations with unparalleled taste and fragrance.",
        image: "/microgreens.jpg",
        features: [
            "Helthy food",
            "Beautiful skin",
            "Right in you hands"
        ],
        monthlyPrice: 2000,
        yearlyPrice: 20000,
        isMostPopular: false,
    },
    {
        id: "price_5",
        name: "Edible flowers",
        image: "/microgreens.jpg",
        description:
            "Produce vibrant, edible flowers to decorate plates, creating stunning and gourmet presentations.",
        features: [
            "Helthy food",
            "More energy",
            "Stay cool",
        ],
        monthlyPrice: 5000,
        yearlyPrice: 50000,
        isMostPopular: false,
    },
    {
        id: "price_6",
        name: "Leafy greens",
        description: "Harvest tender leafy greens that provide a healthy, crisp addition to salads and meals.",
        image: "/microgreens.jpg",
        features: [
            "Be happier",
            "Every day",
        ],
        monthlyPrice: 8000,
        yearlyPrice: 80000,
        isMostPopular: false,
    },
];

export default function UsecaseSection() {
    const [interval, setInterval] = useState<Interval>("month");
    const [isLoading, setIsLoading] = useState(false);
    const [id, setId] = useState<string | null>(null);

    const onSubscribeClick = async (priceId: string) => {
        setIsLoading(true);
        setId(priceId);
        await new Promise((resolve) => setTimeout(resolve, 1000)); // Simulate a delay
        setIsLoading(false);
    };

    return (
        <section id="pricing">
            <div className="mx-auto flex max-w-screen-xl flex-col gap-8 px-4 py-14 md:px-8">
                <div className="mx-auto max-w-5xl text-center">
                    <h4 className="text-xl font-bold tracking-tight text-black dark:text-white">
                        Endless possibilities
                    </h4>

                    <h2 className="text-5xl font-bold tracking-tight text-black dark:text-white sm:text-6xl">
                        Discover what you can grov.
                    </h2>

                    <p className="mt-6 text-xl leading-8 text-black/80 dark:text-white">
                        Choose an <strong>what you wish</strong> to harvest using the app and get it done by the smartest farm right in your kitchen.
                    </p>
                </div>

                <div className="mx-auto grid w-full justify-center sm:grid-cols-2 lg:grid-cols-4 flex-col gap-4">
                    {caseCards.map((item, idx) => (
                        <div
                            key={item.id}
                            className={cn(
                                "relative flex max-w-[400px] flex-col gap-8 rounded-2xl border p-6 text-black dark:text-white overflow-hidden",
                                {
                                    "border-2 border-[var(--color-one)] dark:border-[var(--color-one)]":
                                        item.isMostPopular,
                                }
                            )}
                        >
                            <div className="flex items-center gap-4">
                                <div className="ml-4">
                                    <h2 className="text-base font-semibold leading-7">
                                        {item.name}
                                    </h2>
                                    <p className="h-12 text-sm leading-5 text-black/70 dark:text-white my-4">
                                        {item.description}
                                    </p>
                                </div>
                            </div>

                            <Image
                                src={item.image}
                                alt={item.name}
                                width={512}
                                height={512}
                                className={"rounded-lg object-cover my-4"}
                            />

                            {/* <Button
                                className={cn(
                                    "group relative w-full gap-2 overflow-hidden text-lg font-semibold tracking-tighter",
                                    "transform-gpu ring-offset-current transition-all duration-300 ease-out hover:ring-2 hover:ring-primary hover:ring-offset-2"
                                )}
                                disabled={isLoading}
                                onClick={() => void onSubscribeClick(item.id)}
                            >
                                <span className="absolute right-0 -mt-12 h-32 w-8 translate-x-12 rotate-12 transform-gpu bg-white opacity-10 transition-all duration-1000 ease-out group-hover:-translate-x-96 dark:bg-black" />
                                {(!isLoading || (isLoading && id !== item.id)) && (
                                    <p>Subscribe</p>
                                )}

                                {isLoading && id === item.id && <p>Subscribing</p>}
                                {isLoading && id === item.id && (
                                    <Loader className="mr-2 h-4 w-4 animate-spin" />
                                )}
                            </Button> */}

                            <hr className="m-0 h-px w-full border-none bg-gradient-to-r from-neutral-200/0 via-neutral-500/30 to-neutral-200/0" />
                            {item.features && item.features.length > 0 && (
                                <ul className="flex flex-col gap-2 font-normal">
                                    {item.features.map((feature: any, idx: any) => (
                                        <li
                                            key={idx}
                                            className="flex items-center gap-3 text-xs font-medium text-black dark:text-white"
                                        >
                                            <CheckIcon className="h-5 w-5 shrink-0 rounded-full bg-green-400 p-[2px] text-black dark:text-white" />
                                            <span className="flex">{feature}</span>
                                        </li>
                                    ))}
                                </ul>
                            )}
                        </div>
                    ))}
                </div>
            </div>
        </section>
    );
}
