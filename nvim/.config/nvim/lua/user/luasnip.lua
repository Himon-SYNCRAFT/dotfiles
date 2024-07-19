require("luasnip.loaders.from_snipmate").lazy_load()
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local postfix = require("luasnip.extras.postfix").postfix

ls.config.setup({
	enable_autosnippets = true,
})

vim.keymap.set({ "i" }, "<C-K>", function()
	ls.expand()
end, { silent = true })

-- vim.keymap.set({ "i", "s" }, "<Tab>", function()
-- 	ls.jump(1)
-- end, { silent = true })

-- vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
-- 	ls.jump(-1)
-- end, { silent = true })

-- vim.keymap.set({ "i", "s" }, "<C-E>", function()
-- 	if ls.choice_active() then
-- 		ls.change_choice(1)
-- 	end
-- end, { silent = true })
--
local function find_git_root()
	local path = vim.fn.expand("%:p:h")
	local root = nil
	while path ~= "/" and path ~= "" do
		if vim.fn.isdirectory(path .. "/.git") ~= 0 then
			root = path
			break
		end
		path = vim.fn.fnamemodify(path, ":h")
	end
	return root
end

local function get_namespace_for_src()
	local root = find_git_root()
	local file_path = root .. "/composer.json"
	local json = vim.fn.readfile(file_path)

	if #json == 0 then
		print("Nie znaleziono pliku composer.json")
		return ""
	end

	local json_content = table.concat(json, "")
	local ok, data = pcall(vim.fn.json_decode, json_content)

	if not ok or not data then
		print("Błąd przy dekodowaniu pliku composer.json")
		return ""
	end

	if data.autoload and data.autoload["psr-4"] then
		for namespace, path in pairs(data.autoload["psr-4"]) do
			if path == "src/" or path == "./src/" then
				return namespace
			end
		end
	end

	print("Nie znaleziono namespace dla src/ w composer.json")
	return ""
end

local function get_filename()
	local full_path = vim.fn.expand("%:p")
	local file_basename = vim.fn.fnamemodify(full_path, ":t:r")
	return file_basename
end

local function get_current_file_directory()
	local full_path = vim.fn.expand("%:p")
	local directory_path = vim.fn.fnamemodify(full_path, ":h")
	local directory_name = vim.fn.fnamemodify(directory_path, ":t")
	return directory_name
end

local function first_to_lower(values)
	local str = values[1][1]
	if str == nil or str == "" then
		return str
	end
	return str:sub(1, 1):lower() .. str:sub(2)
end

local function get_first_letter_lowercase(values)
	local str = values[1][1]
	if str == nil or str == "" then
		return ""
	end
	return str:sub(1, 1):lower()
end

local function get_namespace()
	local buf = vim.api.nvim_get_current_buf()
	local filepath = vim.api.nvim_buf_get_name(buf)
	local src_start = filepath:find("src/")

	if src_start then
		local start_pos = src_start + #"src/"

		local last_slash = filepath:match(".*()/")

		if last_slash and last_slash > start_pos then
			local subpath = filepath:sub(start_pos, last_slash - 1)
			return subpath:gsub("/", "\\")
		else
			return ""
		end
	else
		return filepath
	end
end

ls.add_snippets("php", {
	s(
		"cl",
		fmt(
			[[
            <?php

            declare(strict_types=1);

            namespace `root#`namespace#;

            class `class_name#
            {
                `class_content#
            }
            ]],
			{
				root = f(get_namespace_for_src),
				namespace = f(get_namespace),
				class_name = f(get_filename),
				class_content = i(1),
			},
			{ delimiters = "`#" }
		)
	),
	s(
		"ent",
		fmt(
			[[
            <?php

            declare(strict_types=1);

            namespace `root^`namespace^;

            use Doctrine\ORM\Mapping as ORM;

            #[ORM\Entity()]
            class `class_name^
            {
                #[ORM\Id]
                #[ORM\GeneratedValue]
                #[ORM\Column]
                private ?int $id = null;

                `class_content^

                public function getId(): ?int
                {
                    return $this->id;
                }

                public function setId(?int $id): self
                {
                    $this->id = $id;
                    return $this;
                }
            }
            ]],
			{
				root = f(get_namespace_for_src),
				namespace = f(get_namespace),
				class_name = f(get_filename),
				class_content = i(1),
			},
			{ delimiters = "`^" }
		)
	),
	s(
		"repo",
		fmt(
			[[
            <?php

            declare(strict_types=1);

            namespace `root^`namespace^;

            use Doctrine\ORM\EntityManagerInterface;
            use Doctrine\ORM\QueryBuilder;

            class `class_name^
            {
                public function __construct(
                    private EntityManagerInterface $_em,
                ) {
                }

                public function findById(int $id): ?`find_by_id_type^
                {
                    return $this->createQueryBuilder('`alias^')
                        ->where('`alias^.id = :id')
                        ->setParameter('id', $id)
                        ->getQuery()
                        ->getOneOrNullResult();
                }

                public function save(`entity_name^ $`lowercased_entity_name^, bool $flush = false): void
                {
                    $this->_em->persist($`lowercased_entity_name^);

                    if ($flush) {
                        $this->_em->flush();
                    }
                }

                /**
                * @param `item_type^[] $items
                */
                public function saveAll(array $items, bool $flush = false): void
                {
                    foreach ($items as $item) {
                        $this->_em->persist($item);
                    }

                    if ($flush) {
                        $this->_em->flush();
                    }
                }`end_^

                private function createQueryBuilder(string $alias, ?string $indexBy = null): QueryBuilder
                {
                    return $this->_em->createQueryBuilder()
                        ->select($alias)
                        ->from(`from^::class, $alias, $indexBy);
                }
            }
            ]],
			{
				root = f(get_namespace_for_src),
				namespace = f(get_namespace),
				class_name = f(get_filename),
				entity_name = i(1),
				find_by_id_type = rep(1),
				item_type = rep(1),
				lowercased_entity_name = f(first_to_lower, { 1 }),
				from = rep(1),
				end_ = i(0),
				alias = f(get_first_letter_lowercase, { 1 }),
			},
			{ delimiters = "`^" }
		)
	),
	s(
		"controller",
		fmt(
			[[
            <?php

            declare(strict_types=1);

            namespace `root^`namespace^;

            use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
            use Symfony\Component\HttpFoundation\Request;
            use Symfony\Component\HttpFoundation\Response;
            use Symfony\Component\Routing\Attribute\Route;

            class `class_name^ extends AbstractController
            {
                `end_^
            }
            ]],
			{
				root = f(get_namespace_for_src),
				namespace = f(get_namespace),
				class_name = f(get_filename),
				end_ = i(0),
			},
			{ delimiters = "`^" }
		)
	),
	s(
		"crud",
		fmt(
			[[
            <?php

            declare(strict_types=1);

            namespace `root^`namespace^;

            use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;

            class `class_name^ extends AbstractCrudController
            {
                public static function getEntityFqcn(): string
                {
                    return `typ_^::class;
                }
            }
            ]],
			{
				root = f(get_namespace_for_src),
				namespace = f(get_namespace),
				class_name = f(get_filename),
				typ_ = i(1),
			},
			{ delimiters = "`^" }
		)
	),
	s(
		"route",
		fmt(
			[[
            #[Route('`url^', name: '`route_name^', methods: [`methods^])]
            public function `func^(): Response
            {
                `end_^
            }
            ]],
			{
				url = i(1),
				route_name = i(2),
				methods = i(3, '"GET"'),
				func = i(4),
				end_ = i(0),
			},
			{ delimiters = "`^" }
		)
	),
	s(
		"get",
		fmt(
			[[
            public function get`name#(): `typ#
            {
                return $this->`lowercased_name#;
            }
            ]],
			{
				name = i(1, "Name"),
				typ = i(2, "Type"),
				lowercased_name = f(first_to_lower, { 1 }),
			},
			{ delimiters = "`#" }
		)
	),
	s(
		"pubfn",
		fmt(
			[[
            public function `name#(`args#): `typ#
            {
                `end_#
            }
            ]],
			{
				name = i(1, "functionName"),
				typ = i(2, "returnType"),
				args = i(3, "args"),
				end_ = i(0),
			},
			{ delimiters = "`#" }
		)
	),
	s(
		"privfn",
		fmt(
			[[
            private function `name#(`args#): `typ#
            {
                `end_#
            }
            ]],
			{
				name = i(1, "functionName"),
				typ = i(2, "returnType"),
				args = i(3, "args"),
				end_ = i(0),
			},
			{ delimiters = "`#" }
		)
	),
	s(
		"con",
		fmt(
			[[
		public function __construct(
			`#
		) {
		}
		]],
			{
				i(1),
			},
			{ delimiters = "`#" }
		)
	),
	s(
		"set",
		fmt(
			[[
            public function set`name#(`typ# $`lowercased_name#): self
            {
                $this->`lowercased_name# = $`lowercased_name#;
                return $this;
            }
            ]],
			{
				name = i(1, "Name"),
				typ = i(2, "Type"),
				lowercased_name = f(first_to_lower, { 1 }),
			},
			{ delimiters = "`#" }
		)
	),
	s(
		"match",
		fmt(
			[[
            match (`arg#) {
                `case# => `return_#,
            };
            ]],
			{
				arg = i(1, "arg"),
				case = i(2, "case"),
				return_ = i(3, "return"),
			},
			{ delimiters = "`#" }
		)
	),
	s(
		"manytoone",
		fmt(
			[[
            #[ORM\ManyToOne(targetEntity: `targetClass^::class)]
            #[ORM\JoinColumn(name: '`sourceId^', referencedColumnName: '`referencedColumnName^')]
            private `entity^ $`lowercased_typ^;
            ]],
			{
				targetClass = i(1, "Target"),
				sourceId = i(2, "source_id"),
				referencedColumnName = i(3, "id"),
				entity = rep(1),
				lowercased_typ = f(first_to_lower, { 1 }),
			},
			{ delimiters = "`^" }
		)
	),
	s(
		"onetoone",
		fmt(
			[[
            #[ORM\OneToOne(targetEntity: `targetClass^::class)]
            #[ORM\JoinColumn(name: '`sourceId^', referencedColumnName: '`referencedColumnName^')]
            private `entity^ $`lowercased_typ^;
            ]],
			{
				targetClass = i(1, "Target"),
				sourceId = i(2, "source_id"),
				referencedColumnName = i(3, "id"),
				entity = rep(1),
				lowercased_typ = f(first_to_lower, { 1 }),
			},
			{ delimiters = "`^" }
		)
	),
	s(
		"onetomany",
		fmt(
			[[
            /**
            * @var Collection<int, `entity^>
            */
            #[ORM\JoinTable(name: '`joinTable^')]
            #[ORM\JoinColumn(name: '`sourceId^', referencedColumnName: '`targetColumnName^')]
            #[ORM\InverseJoinColumn(name: '`targetId^', referencedColumnName: '`sourceColumnName^', unique: true)]
            #[ORM\ManyToMany(targetEntity: `targetClass^::class)]
            private Collection $`lowercased_typ^s;
            ]],
			{
				targetClass = i(1, "Target"),
				sourceId = i(2, "source_id"),
				targetColumnName = i(3, "id"),
				targetId = i(4, "source_id"),
				sourceColumnName = i(5, "id"),
				joinTable = i(6, "joinTable"),
				lowercased_typ = f(first_to_lower, { 1 }),
				entity = rep(1),
			},
			{ delimiters = "`^" }
		)
	),
	s(
		"manytomany",
		fmt(
			[[
            /**
            * @var Collection<int, `entity^>
            */
            #[ORM\JoinTable(name: '`joinTable^')]
            #[ORM\JoinColumn(name: '`sourceId^', referencedColumnName: '`targetColumnName^')]
            #[ORM\InverseJoinColumn(name: '`targetId^', referencedColumnName: '`sourceColumnName^')]
            #[ORM\ManyToMany(targetEntity: `targetClass^::class)]
            private Collection $`lowercased_typ^s;
            ]],
			{
				targetClass = i(1, "Target"),
				sourceId = i(2, "source_id"),
				targetColumnName = i(3, "id"),
				targetId = i(4, "source_id"),
				sourceColumnName = i(5, "id"),
				joinTable = i(6, "joinTable"),
				lowercased_typ = f(first_to_lower, { 1 }),
				entity = rep(1),
			},
			{ delimiters = "`^" }
		)
	),
	s(
		"enum",
		fmt(
			[[
            <?php

            declare(strict_types=1);

            namespace `root#`namespace#;

            enum `enum_name#: string
            {
                case `case_name# = '`case#';
            }
            ]],
			{
				root = f(get_namespace_for_src),
				namespace = f(get_namespace),
				enum_name = f(get_filename),
				case_name = i(1),
				case = i(2),
			},
			{ delimiters = "`#" }
		)
	),
	s(
		"ifnull",
		fmt(
			[[
            if (`arg# === null) {
                `content#
            }
            ]],
			{
				arg = i(1),
				content = i(0),
			},
			{ delimiters = "`#" }
		)
	),
	postfix({
		trig = ".var",
		match_pattern = "^%s*(.*)",
		snippetType = "autosnippet",
	}, {
		d(1, function(_, parent)
			return sn(1, fmt("${} = " .. parent.snippet.env.POSTFIX_MATCH, { i(1, "name") }))
		end),
	}),
})
